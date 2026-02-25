import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../data/repositories/ws_auth_repository.dart';

class PaymentWsService {
  PaymentWsService({required this.authRepo, this.enableLogs = true}) {
    print(
      '[WS] PaymentWsService created enableLogs=$enableLogs hash=${identityHashCode(this)}',
    );
  }

  final bool enableLogs;
  final WsAuthRepository authRepo;

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  bool _initialized = false;

  // untuk cegah connect ganda / race condition
  Future<String>? _connectTask;

  final Set<String> _subscribedChannels = <String>{};

  final _eventCtrl = StreamController<PusherEvent>.broadcast();
  Stream<PusherEvent> get events => _eventCtrl.stream;

  final _stateCtrl = StreamController<String>.broadcast();
  Stream<String> get connectionStates => _stateCtrl.stream;

  void _log(String msg) {
    if (!enableLogs) return;
    // ignore: avoid_print
    print('[WS] $msg');
  }

  String _requireEnv(String key, {String? hint}) {
    final value = dotenv.env[key]?.trim() ?? '';
    if (value.isEmpty) throw StateError("Missing env var: $key\n${hint ?? ''}");
    return value;
  }

  String _mask(String v, {int keepStart = 4, int keepEnd = 3}) {
    final s = v.trim();
    if (s.isEmpty) return '(empty)';
    if (s.length <= keepStart + keepEnd) return '*' * s.length;
    return '${s.substring(0, keepStart)}...${s.substring(s.length - keepEnd)}';
  }

  void _logEnv({
    required String pusherKey,
    required String cluster,
    required String authUrl,
    required String apiToken,
  }) {
    _log(
      'ENV loaded: '
      'PUSHER_KEY=${_mask(pusherKey)} | '
      'WS_CLUSTER=$cluster | '
      'WS_AUTH_URL=$authUrl | '
      'API_TOKEN_WS=${_mask(apiToken)}',
    );
  }

  Future<void> initIfNeeded() async {
    if (enableLogs) {
      // ignore: avoid_print
      print('[WS] PaymentWsService created hash=${identityHashCode(this)}');
    }

    if (_initialized) return;

    final pusherKey = _requireEnv('PUSHER_KEY', hint: "PUSHER_KEY=xxxxx");
    final cluster = (dotenv.env['WS_CLUSTER']?.trim().isNotEmpty ?? false)
        ? dotenv.env['WS_CLUSTER']!.trim()
        : 'ap1';
    final authUrl = _requireEnv(
      'WS_AUTH_URL',
      hint: "WS_AUTH_URL=https://.../broadcasting/auth",
    );
    final apiToken = _requireEnv('API_TOKEN_WS', hint: "API_TOKEN_WS=kasprima");

    // ✅ cek env sudah kebaca
    _logEnv(
      pusherKey: pusherKey,
      cluster: cluster,
      authUrl: authUrl,
      apiToken: apiToken,
    );

    await _pusher.init(
      apiKey: pusherKey,
      cluster: cluster,
      useTLS: true,
      authEndpoint: authUrl,
      onConnectionStateChange: (current, previous) {
        _log('connection: $previous -> $current');
        _stateCtrl.add(current);
      },
      onAuthorizer:
          (String channelName, String socketId, dynamic options) async {
            _log('authorizing channel=$channelName socketId=$socketId');
            final data = await authRepo.authorize(
              authUrl: authUrl,
              apiToken: apiToken,
              socketId: socketId,
              channelName: channelName,
            );
            _log('auth OK for $channelName');
            return data;
          },
      onError: (String message, int? code, dynamic error) {
        _log('Pusher error $code: $message ${error ?? ''}');
      },
      onEvent: (PusherEvent event) {
        _log(
          'event IN channel=${event.channelName} event=${event.eventName} data=${event.data}',
        );
        _eventCtrl.add(event);
      },
    );

    _initialized = true;
  }

  /// Normalisasi socketId dari plugin:
  /// - plugin bisa balikin "null" (string) -> treat as null
  String? _normalizeSocketId(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'null') return null;
    return s;
  }

  /// Ambil socketId kalau sudah tersedia (tanpa menunggu).
  Future<String?> _tryGetSocketId() async {
    try {
      final raw = await _pusher
          .getSocketId(); // di plugin kamu return String, tapi bisa "null"
      return _normalizeSocketId(raw);
    } catch (e) {
      _log('getSocketId() error: $e');
      return null;
    }
  }

  /// Connect dan pastikan socketId READY.
  /// Return socketId valid, atau throw TimeoutException.
  Future<String> connect({
    Duration timeout = const Duration(seconds: 12),
    Duration pollInterval = const Duration(milliseconds: 200),
  }) async {
    await initIfNeeded();

    // kalau ada connect yang sedang berjalan, tunggu task yang sama
    _connectTask ??= _connectImpl(timeout: timeout, pollInterval: pollInterval);

    try {
      final sid = await _connectTask!;
      return sid;
    } finally {
      // setelah selesai (sukses/gagal), reset supaya bisa retry connect berikutnya
      _connectTask = null;
    }
  }

  Future<String> _connectImpl({
    required Duration timeout,
    required Duration pollInterval,
  }) async {
    // Kalau ternyata socketId sudah ada, langsung pakai
    final existing = await _tryGetSocketId();
    if (existing != null) {
      _log('socketId already READY: $existing');
      return existing;
    }

    _log('connecting...');
    await _pusher.connect();
    _log('connect() called');

    final endAt = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endAt)) {
      final sid = await _tryGetSocketId();
      if (sid != null) {
        _log('socketId READY: $sid');
        return sid;
      }
      await Future.delayed(pollInterval);
    }

    throw TimeoutException(
      'socketId masih null setelah ${timeout.inSeconds}s (koneksi belum CONNECTED / gagal)',
    );
  }

  Future<void> subscribe(String channelName) async {
    // pastikan connect benar-benar ready (socketId ada)
    await connect();

    if (_subscribedChannels.contains(channelName)) {
      _log('skip subscribe (already): $channelName');
      return;
    }

    _log('subscribing: $channelName');
    await _pusher.subscribe(channelName: channelName);
    _subscribedChannels.add(channelName);
    _log('subscribed: $channelName');
  }

  Future<void> unsubscribe(String channelName) async {
    if (!_subscribedChannels.contains(channelName)) return;

    _log('unsubscribing: $channelName');
    try {
      await _pusher.unsubscribe(channelName: channelName);
    } catch (e) {
      _log('unsubscribe error: $e');
    } finally {
      _subscribedChannels.remove(channelName);
    }
  }

  Future<void> disconnectAll() async {
    final channels = _subscribedChannels.toList(growable: false);
    for (final ch in channels) {
      await unsubscribe(ch);
    }
    try {
      _log('disconnecting...');
      await _pusher.disconnect();
    } catch (_) {}
  }
}
