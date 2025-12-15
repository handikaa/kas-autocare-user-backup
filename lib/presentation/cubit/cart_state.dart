part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<ChartEntity> cartItems;

  const CartLoaded(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

/// 🔹 Untuk aksi kecil seperti hapus/update
class CartActionLoading extends CartState {}

class CartActionSuccess extends CartState {
  final String message;

  const CartActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CartActionError extends CartState {
  final String message;

  const CartActionError(this.message);

  @override
  List<Object?> get props => [message];
}
