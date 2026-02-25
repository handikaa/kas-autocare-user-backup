part of 'create_booking_cubit.dart';

abstract class CreateBookingState extends Equatable {
  const CreateBookingState();

  @override
  List<Object?> get props => [];
}

class CreateBookingInitial extends CreateBookingState {}

class CreateBookingLoading extends CreateBookingState {}

class CreateBookingSuccess extends CreateBookingState {
  final TransactionEntity data;

  const CreateBookingSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class CreateBookingError extends CreateBookingState {
  final String message;

  const CreateBookingError(this.message);

  @override
  List<Object?> get props => [message];
}
