// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/utils/navigation_service.dart';
import 'package:kas_autocare_user/data/datasource/local/auth_local_data_source.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sentry/sentry.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BaseRemoteHandler {
  final Dio dio;

  BaseRemoteHandler(this.dio) {
    if (kDebugMode) {
      // Hindari dobel interceptor kalau BaseRemoteHandler dibuat berkali-kali
      final alreadyAdded = dio.interceptors.any(
        (i) => i.runtimeType == PrettyDioLogger,
      );

      if (!alreadyAdded) {
        dio.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: true,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );
      }
    }
  }

  /// (GET / POST / PUT / DELETE)
  Future<dynamic> request({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withAuth = true,
  }) async {
    try {
      // Default header
      final Map<String, dynamic> finalHeaders = {};

      if (headers != null && headers.isNotEmpty) {
        finalHeaders.addAll(headers);
      }

      dio.options.headers = finalHeaders;

      Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await dio.post(endpoint, data: data);
          break;
        case 'PUT':
          response = await dio.put(endpoint, data: data);
          break;
        case 'DELETE':
          response = await dio.delete(endpoint, data: data);
          break;
        default:
          response = await dio.get(endpoint, queryParameters: queryParameters);
      }

      final statusCode = response.statusCode ?? 500;

      if (statusCode == 200 || statusCode == 201) {
        final resData = response.data;

        if (resData is Map<String, dynamic> && resData.containsKey('data')) {
          return resData['data'];
        }

        return resData;
      }

      final message = response.data?['error'] ?? 'Gagal memproses permintaan';

      throw Exception(message);
    } on DioException catch (e, stackTrace) {
      final String errorMessage;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Koneksi ke server timeout. Periksa jaringan Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final data = e.response?.data;
        String extractedMessage =
            'Server mengembalikan kesalahan (${e.response?.statusCode})';

        if (e.response?.statusCode == 401 &&
            (data is Map && data['message'] == 'Unauthorized access')) {
          await AuthLocalDataSource().clearAuth();

          // AuthEventBus.triggerUnauthorized();

          final ctx = NavigationService.rootNavigatorKey.currentContext;

          if (ctx != null) {
            ctx.go('/login');
          }

          return Future.error("Sesi telah berakhir, silakan login kembali.");
        }

        if (data != null) {
          if (data is Map<String, dynamic>) {
            // ---- Ambil message global jika ada
            if (data.containsKey('message') && data['message'] is String) {
              extractedMessage = data['message'];
            }

            // ---- Ambil detail errors jika ada
            if (data.containsKey('errors') &&
                data['errors'] is Map<String, dynamic>) {
              final errors = data['errors'] as Map<String, dynamic>;

              // Ambil semua pesan error menjadi satu
              final errorMessages = <String>[];

              errors.forEach((key, value) {
                if (value is List && value.isNotEmpty) {
                  errorMessages.add(value.first.toString());
                } else if (value is String) {
                  errorMessages.add(value);
                }
              });

              // Jika ada error validasi, gabungkan mereka
              if (errorMessages.isNotEmpty) {
                extractedMessage = errorMessages.join(
                  "\n",
                ); // bisa pakai bullet jika mau
              }
            }
          }
        }

        errorMessage = extractedMessage;
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Jaringan bermasalah silahkan coba lagi nanti';
      } else {
        errorMessage = 'Terjadi kesalahan koneksi (${e.message})';
      }

      await _captureSentryException(
        e,
        stackTrace,
        endpoint: endpoint,
        method: method,
        payload: data,
        queryParameters: queryParameters,
        message: errorMessage,
      );

      throw Exception(errorMessage);
    } on TimeoutException catch (e, stackTrace) {
      const msg = 'Waktu koneksi habis. Silakan coba lagi.';

      await _captureSentryException(
        e,
        stackTrace,
        endpoint: endpoint,
        method: method,
        payload: data,
        queryParameters: queryParameters,
        message: msg,
      );

      throw Exception(msg);
    } catch (e, stackTrace) {
      final msg = 'Terjadi kesalahan tidak terduga: $e';

      await _captureSentryException(
        e,
        stackTrace,
        endpoint: endpoint,
        method: method,
        payload: data,
        queryParameters: queryParameters,
        message: msg,
      );

      throw Exception(msg);
    }
  }

  Future<void> _captureSentryException(
    dynamic exception,
    StackTrace stackTrace, {
    required String endpoint,
    required String method,
    Map<String, dynamic>? payload,
    Map<String, dynamic>? queryParameters,
    String? message,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.setTag('endpoint', endpoint);
        scope.setTag('method', method);
        if (message != null) scope.setExtra('error', message);
        if (payload != null) scope.setExtra('payload', payload);
        if (queryParameters != null) {
          scope.setExtra('queryParams', queryParameters);
        }
      },
    );
  }
}
