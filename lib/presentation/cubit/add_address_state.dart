part of 'add_address_cubit.dart';

abstract class AddAddressState extends Equatable {
  const AddAddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddAddressState {}

class AddressLoading extends AddAddressState {}

class DetailAddressLoading extends AddAddressState {}

class AddressLoaded extends AddAddressState {
  final String message;

  const AddressLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class DetailAddressLoaded extends AddAddressState {
  final AddressEntity data;

  const DetailAddressLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class AddressError extends AddAddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}

class DetailAddressError extends AddAddressState {
  final String message;

  const DetailAddressError(this.message);

  @override
  List<Object?> get props => [message];
}
