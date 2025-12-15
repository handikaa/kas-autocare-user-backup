part of 'forgot_pass_cubit.dart';

abstract class ForgotPassState extends Equatable {
  const ForgotPassState();

  @override
  List<Object?> get props => [];
}

class ForgotPassInitial extends ForgotPassState {}

class ForgotPassLoading extends ForgotPassState {}

class ForgotPassSuccess extends ForgotPassState {
  final String message;

  const ForgotPassSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ForgotPassError extends ForgotPassState {
  final String message;

  const ForgotPassError(this.message);

  @override
  List<Object?> get props => [message];
}

class SendForgotInitial extends ForgotPassState {}

class SendForgotLoading extends ForgotPassState {}

class SendForgotSuccess extends ForgotPassState {
  final String message;

  const SendForgotSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SendForgotError extends ForgotPassState {
  final String message;

  const SendForgotError(this.message);

  @override
  List<Object?> get props => [message];
}
