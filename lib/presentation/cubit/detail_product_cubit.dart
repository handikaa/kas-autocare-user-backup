import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecase/fetch_detail_product.dart';

part 'detail_product_state.dart';

class DetailProductCubit extends Cubit<DetailProductState> {
  final FetchDetailProduct fetchDetailProduct;

  DetailProductCubit(this.fetchDetailProduct) : super(DetailProductInitial());

  Future<void> getDetailProduct(int id) async {
    emit(DetailProductLoading());

    final result = await fetchDetailProduct.execute(id);

    result.fold(
      (l) => emit(DetailProductError(l)),
      (r) => emit(DetailProductSuccess(r)),
    );
  }
}
