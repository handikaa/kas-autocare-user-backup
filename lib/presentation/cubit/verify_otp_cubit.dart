import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/send_otp.dart';
import '../../domain/usecase/verify_otp.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOtp usecase;
  final SendOtp useCasesendOtp;

  VerifyOtpCubit(this.usecase, this.useCasesendOtp) : super(VerifyOTPInitial());

  Future<void> verifyOtp({required String email, required String code}) async {
    emit(VerifyOTPLoading());
    final result = await usecase.execute(email: email, code: code);

    result.fold(
      (l) => emit(VerifyOTPError(l)),
      (r) => emit(VerifyOTPSuccess(r)),
    );
  }

  Future<void> sendOtp({required String email}) async {
    emit(SendOtpLoading());
    final result = await useCasesendOtp.execute(email: email);

    result.fold((l) => emit(SendOtpError(l)), (r) => emit(SendOtpLoaded(r)));
  }
}
