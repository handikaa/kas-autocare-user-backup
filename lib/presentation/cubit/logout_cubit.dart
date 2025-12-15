import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/local/auth_local_data_source.dart';
import '../../domain/usecase/logout_user.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUser doLogout;

  LogoutCubit(this.doLogout) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await doLogout.execute();

    result.fold((l) => emit(LogoutError(l)), (r) async {
      await AuthLocalDataSource().clearAuth();

      emit(LogoutSuccess(r));
    });
  }
}
