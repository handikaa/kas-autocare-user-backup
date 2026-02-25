import 'dart:convert';

import 'package:dio/dio.dart';

abstract class WsAuthRepository {
  Future<Map<String, dynamic>> authorize({
    required String authUrl,
    required String apiToken,
    required String socketId,
    required String channelName,
  });
}

class WsAuthRepositoryImpl implements WsAuthRepository {
  final Dio dio;
  WsAuthRepositoryImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> authorize({
    required String authUrl,
    required String apiToken,
    required String socketId,
    required String channelName,
  }) async {
    final sid = socketId.trim();
    final ch = channelName.trim();

    if (sid.isEmpty || sid.toLowerCase() == 'null') {
      throw ArgumentError('socketId kosong/null. Pastikan WS sudah CONNECTED.');
    }
    if (ch.isEmpty) {
      throw ArgumentError('channelName kosong.');
    }

    try {
      final res = await dio.post(
        authUrl,
        options: Options(
          headers: {
            'X-API-TOKEN': apiToken,
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {'socket_id': sid, 'channel_name': ch},
      );

      final data = res.data;

      // Pusher authorizer butuh Map<String, dynamic>
      if (data is Map<String, dynamic>) return data;

      if (data is Map) {
        // Map<dynamic, dynamic> -> Map<String, dynamic>
        return Map<String, dynamic>.from(data);
      }

      if (data is String) {
        final decoded = jsonDecode(data);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      }

      throw Exception(
        'Invalid auth response type: ${data.runtimeType}, value=$data',
      );
    } on DioException catch (e) {
      // Bikin error lebih informatif
      final status = e.response?.statusCode;
      final body = e.response?.data;
      throw Exception('WS auth failed (HTTP $status): $body');
    }
  }
}
