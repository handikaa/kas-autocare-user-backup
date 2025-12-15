import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/usecase/forgot_send_otp.dart';
import 'package:kas_autocare_user/domain/usecase/forgot_verify_otp.dart';
import 'package:kas_autocare_user/domain/usecase/reset_pass.dart';

part 'forgot_pass_state.dart';

class ForgotPassCubit extends Cubit<ForgotPassState> {
  final ForgotSendOtp forgotSendOtp;
  final ForgotVerifyOtp forgotVerifyOtp;
  final ResetPass resetPass;

  ForgotPassCubit(this.forgotSendOtp, this.forgotVerifyOtp, this.resetPass)
    : super(ForgotPassInitial());

  Future<void> verifyOtp({required String email, required String code}) async {
    emit(ForgotPassLoading());
    final result = await forgotVerifyOtp.execute(email: email, otp: code);

    result.fold(
      (l) => emit(ForgotPassError(l)),
      (r) => emit(ForgotPassSuccess(r)),
    );
  }

  Future<void> passwordReset({
    required String email,
    required String pass,
    required String confirmPass,
  }) async {
    emit(ForgotPassLoading());
    final result = await resetPass.execute(
      email: email,
      pass: pass,
      confirmPass: confirmPass,
    );

    result.fold(
      (l) => emit(ForgotPassError(l)),
      (r) => emit(ForgotPassSuccess(r)),
    );
  }

  Future<void> sendOtp({required String email}) async {
    emit(SendForgotLoading());
    final result = await forgotSendOtp.execute(email: email);

    result.fold(
      (l) => emit(SendForgotError(l)),
      (r) => emit(SendForgotSuccess(r)),
    );
  }
}
