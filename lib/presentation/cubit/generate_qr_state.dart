part of 'generate_qr_cubit.dart';

abstract class GenerateQrState extends Equatable {
  const GenerateQrState();

  @override
  List<Object?> get props => [];
}

class GenerateQrStateInitial extends GenerateQrState {}

class GenerateQrStateLoading extends GenerateQrState {}

class GenerateQrStateSuccess extends GenerateQrState {
  final QrProductEntity data;

  const GenerateQrStateSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class GenerateQrStateError extends GenerateQrState {
  final String message;

  const GenerateQrStateError(this.message);

  @override
  List<Object?> get props => [message];
}
