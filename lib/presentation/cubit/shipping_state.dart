part of 'shipping_subit.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object?> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingLoaded extends ShippingState {
  final CheckShippingEntity data;

  const ShippingLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ShippingError extends ShippingState {
  final String message;

  const ShippingError(this.message);

  @override
  List<Object?> get props => [message];
}
