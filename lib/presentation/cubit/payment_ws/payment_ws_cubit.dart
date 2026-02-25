import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/config/utils/payment_service_websocket.dart';

part 'payment_ws_state.dart';

class PaymentWsCubit extends Cubit<PaymentWsState> {
  PaymentWsCubit(this._ws) : super(PaymentWsState.idle());

  final PaymentWsService _ws;

  StreamSubscription<PusherEvent>? _evSub;
  StreamSubscription<String>? _connSub;

  String? _activeChannel; // ✅ simpan channel aktif

  String _channelOf(String ref) => 'private-transactions.$ref';

  /// Start listen transaksi berdasarkan reference/code.
  Future<void> startListening(String reference) async {
    final ref = reference.trim();
    if (ref.isEmpty) {
      emit(
        state.copyWith(
          status: PaymentWsStatus.error,
          error: 'Reference kosong',
        ),
      );
      return;
    }

    final channel = _channelOf(ref);
    _activeChannel = channel; // ✅ set aktif lebih dulu

    emit(
      PaymentWsState(
        status: PaymentWsStatus.connecting,
        reference: ref,
        channel: channel,
      ),
    );

    await _connSub?.cancel();
    _connSub = _ws.connectionStates.listen((s) {
      emit(state.copyWith(connState: s));
    });

    await _evSub?.cancel();
    _evSub = _ws.events.listen((event) {
      // log semua event
      debugPrint(
        'eventName=${event.eventName} dataType=${event.data.runtimeType}',
      );

      // proses hanya event bisnis
      if (event.eventName != 'transaction.updated') return;

      // ✅ filter pakai variable, bukan state.channel
      if (_activeChannel == null) return;
      if (event.channelName != _activeChannel) return;

      try {
        final root = _parsePayload(event.data);
        if (root == null) return;

        // Deteksi paid: ambil dari root.status atau root.data.latestTransactionStatus
        final statusStr = root['status']?.toString(); // "PAID"
        final latestTrx = (root['data'] is Map)
            ? (root['data']['latestTransactionStatus']?.toString())
            : null;

        final isPaid = statusStr == 'PAID' || latestTrx == '00';

        emit(
          state.copyWith(
            status: isPaid ? PaymentWsStatus.paid : PaymentWsStatus.waiting,
            payload: root,
            clearError: true,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: PaymentWsStatus.error,
            error: 'Parse error: $e',
          ),
        );
      }
    });

    try {
      await _ws.subscribe(channel);
      emit(state.copyWith(status: PaymentWsStatus.waiting, clearError: true));
    } catch (e) {
      emit(
        state.copyWith(status: PaymentWsStatus.error, error: 'WS error: $e'),
      );
    }
  }

  Map<String, dynamic>? _parsePayload(dynamic data) {
    if (data == null) return null;

    // kalau sudah Map
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);

    // kalau String JSON
    if (data is String) {
      final s = data.trim();
      if (s.isEmpty) return null;

      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);

      return null;
    }

    // tipe lain (misalnya List, int, dll) -> abaikan
    return null;
  }

  Future<void> ensureListening(String reference) async {
    final ref = reference.trim();
    if (ref.isEmpty) return;

    // kalau sudah paid, nggak perlu listen lagi
    if (state.status == PaymentWsStatus.paid) return;

    // kalau belum subscribe / sedang error / idle → start lagi
    final shouldRestart =
        state.status == PaymentWsStatus.idle ||
        state.status == PaymentWsStatus.error ||
        state.channel.isEmpty;

    if (shouldRestart) {
      await startListening(ref);
    }
  }

  Future<void> stopListening({bool emitIdle = true}) async {
    final ch = _activeChannel ?? state.channel;
    _activeChannel = null;

    if (ch.isNotEmpty) {
      try {
        await _ws.unsubscribe(ch);
      } catch (_) {}
    }
    await _evSub?.cancel();
    await _connSub?.cancel();

    // ✅ hanya emit kalau diminta dan cubit belum closed
    if (emitIdle && !isClosed) {
      emit(PaymentWsState.idle());
    }
  }

  @override
  Future<void> close() async {
    // ✅ saat close, cleanup saja, jangan emit
    await stopListening(emitIdle: false);
    return super.close();
  }
}
