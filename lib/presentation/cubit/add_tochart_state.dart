part of 'add_tochart_cubit.dart';

abstract class AddToCartState extends Equatable {
  const AddToCartState();

  @override
  List<Object?> get props => [];
}

class AddToCartInitial extends AddToCartState {}

class AddToCartLoading extends AddToCartState {}

class AddToCartSuccess extends AddToCartState {
  final String message;
  const AddToCartSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddToCartError extends AddToCartState {
  final String message;
  const AddToCartError(this.message);

  @override
  List<Object?> get props => [message];
}
