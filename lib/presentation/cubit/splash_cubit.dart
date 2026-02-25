import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/local/auth_local_data_source.dart';

enum SplashStatus { initial, intro, home, login }

class SplashCubit extends Cubit<SplashStatus> {
  final AuthLocalDataSource local;

  SplashCubit(this.local) : super(SplashStatus.initial);

  Future<void> start() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasSeenIntro = await local.isIntroCompleted();
    final token = await local.getToken();
    final userId = await local.getUserId();

    if (!hasSeenIntro) {
      emit(SplashStatus.intro);
      return;
    }

    if (token == null || userId == null) {
      emit(SplashStatus.login);
      return;
    }

    emit(SplashStatus.home);
  }

  Future<void> finishIntro() async {
    await local.setIntroCompleted();
    emit(SplashStatus.login);
  }

  Future<void> bootstrap() async {
    try {
      // iOS permission (Android biasanya auto, tapi boleh tetap panggil)
      await FirebaseMessaging.instance.requestPermission();

      final token = await FirebaseMessaging.instance.getToken();

      log(token ?? "+", name: "TOKEN FCM");

      if (token != null && token.isNotEmpty) {
        await local.saveTokenFCM(token);
        // optional: kalau user sudah login, sync ke server
        // await repo.updateFcmToken(token);
      }
    } catch (_) {
      // jangan bikin splash gagal cuma gara-gara token
    }

    // lanjut flow splash (cek login, dll)
  }
}
