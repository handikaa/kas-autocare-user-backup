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
}
