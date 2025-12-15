part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final List<ChartEntity> cartList;

  final bool hasReachedEnd;
  final ProductQueryParams params;

  const ProductLoaded({
    required this.cartList,
    required this.products,
    required this.hasReachedEnd,
    required this.params,
  });

  @override
  List<Object?> get props => [products, hasReachedEnd, params];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
