part of 'verify_otp_cubit.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyOTPInitial extends VerifyOtpState {}

class VerifyOTPLoading extends VerifyOtpState {}

class VerifyOTPSuccess extends VerifyOtpState {
  final String message;

  const VerifyOTPSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class VerifyOTPError extends VerifyOtpState {
  final String message;

  const VerifyOTPError(this.message);

  @override
  List<Object?> get props => [message];
}

class SendOtpInitial extends VerifyOtpState {}

class SendOtpLoading extends VerifyOtpState {}

class SendOtpLoaded extends VerifyOtpState {
  final String message;

  const SendOtpLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class SendOtpError extends VerifyOtpState {
  final String message;

  const SendOtpError(this.message);

  @override
  List<Object?> get props => [message];
}
