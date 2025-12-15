import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/authentification_entity.dart';

import '../../data/datasource/local/auth_local_data_source.dart';
import '../../data/params/login_params.dart';
import '../../domain/usecase/login_user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUser loginUser;

  LoginCubit(this.loginUser) : super(LoginInitial());

  Future<void> doLogin({required LoginParams payload}) async {
    emit(LoginLoading());
    final result = await loginUser.execute(payload: payload);

    result.fold((l) => emit(LoginError(l)), (r) async {
      final authLocal = AuthLocalDataSource();

      await authLocal.saveToken(r.accessToken);
      // await authLocal.saveUserId(463);
      await authLocal.saveUserId(r.userId);
      await authLocal.saveCustomerId(r.customerId);

      emit(LoginComplete(r));
    });
  }
}
