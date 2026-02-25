part of 'save_fcm_cubit.dart';

abstract class SaveFcmState extends Equatable {
  const SaveFcmState();

  @override
  List<Object?> get props => [];
}

class SaveFcmInitial extends SaveFcmState {}

class SaveFcmLoading extends SaveFcmState {}

class SaveFcmSuccess extends SaveFcmState {
  final String message;

  const SaveFcmSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SaveFcmError extends SaveFcmState {
  final String message;

  const SaveFcmError(this.message);

  @override
  List<Object?> get props => [message];
}
