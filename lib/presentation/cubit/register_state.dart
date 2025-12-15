part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterCheckEmailInitial extends RegisterState {}

class RegisterCheckEmailLoading extends RegisterState {}

class RegisterCheckEmailLoaded extends RegisterState {
  final bool isAvailable;

  const RegisterCheckEmailLoaded(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

class RegisterCheckEmailError extends RegisterState {
  final String message;

  const RegisterCheckEmailError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterlInitial extends RegisterState {}

class RegisterlLoading extends RegisterState {}

class RegisterlLoaded extends RegisterState {
  final String message;

  const RegisterlLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterlError extends RegisterState {
  final String message;

  const RegisterlError(this.message);

  @override
  List<Object?> get props => [message];
}
