part of 'detail_product_cubit.dart';

abstract class DetailProductState extends Equatable {
  const DetailProductState();

  @override
  List<Object?> get props => [];
}

class DetailProductInitial extends DetailProductState {}

class DetailProductLoading extends DetailProductState {}

class DetailProductSuccess extends DetailProductState {
  final ProductEntity product;

  const DetailProductSuccess(this.product);

  @override
  List<Object?> get props => [product];
}

class DetailProductError extends DetailProductState {
  final String message;

  const DetailProductError(this.message);

  @override
  List<Object?> get props => [message];
}
