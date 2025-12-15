part of 'list_address_cubit.dart';

abstract class ListAddressState extends Equatable {
  const ListAddressState();

  @override
  List<Object?> get props => [];
}

class ListAddressInitial extends ListAddressState {}

class ListAddressLoading extends ListAddressState {}

class DeleteAddressLoading extends ListAddressState {}

class ListAddressLoaded extends ListAddressState {
  final List<AddressEntity> data;

  const ListAddressLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteAddressLoaded extends ListAddressState {
  final String message;

  const DeleteAddressLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class ListAddressError extends ListAddressState {
  final String message;

  const ListAddressError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteAddressError extends ListAddressState {
  final String message;

  const DeleteAddressError(this.message);

  @override
  List<Object?> get props => [message];
}
