import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/chart_entity.dart';
import 'package:kas_autocare_user/domain/usecase/get_list_chart.dart';

import '../../data/params/product_query_params.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecase/fetch_list_product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FetchListProduct fetchListProduct;
  final GetListChart getListChart;

  ProductCubit(this.fetchListProduct, this.getListChart)
    : super(ProductInitial());

  int _currentPage = 1;
  bool _hasReachedEnd = false;
  bool _isFetching = false;
  List<ProductEntity> _products = [];
  List<ChartEntity> _cartList = [];

  ProductQueryParams _currentParams = const ProductQueryParams(page: 1);

  ProductQueryParams get currentParams => _currentParams;

  Future<void> getInitialProducts({ProductQueryParams? params}) async {
    emit(ProductLoading());

    _currentPage = 1;
    _hasReachedEnd = false;
    _products.clear();

    _currentParams = params ?? const ProductQueryParams(page: 1);

    final result = await fetchListProduct.execute(_currentParams);

    result.fold((error) => emit(ProductError(error)), (data) {
      _products = data;
      emit(
        ProductLoaded(
          cartList: _cartList,

          products: _products,
          hasReachedEnd: data.isEmpty,
          params: _currentParams,
        ),
      );
    });
  }

  Future<void> loadMoreProducts() async {
    if (_isFetching || _hasReachedEnd) return;
    _isFetching = true;

    final nextParams = _currentParams.copyWith(page: _currentPage + 1);
    final result = await fetchListProduct.execute(nextParams);

    result.fold((error) => emit(ProductError(error)), (data) {
      if (data.isEmpty) {
        _hasReachedEnd = true;
      } else {
        _currentPage++;
        _products.addAll(data);
      }

      emit(
        ProductLoaded(
          cartList: _cartList,

          products: List<ProductEntity>.from(_products),
          hasReachedEnd: _hasReachedEnd,
          params: _currentParams,
        ),
      );
    });

    _isFetching = false;
  }

  Future<void> fetchCart() async {
    final result = await getListChart.execute();
    result.fold(
      (failure) {
        emit(ProductError(failure));
      },
      (cartList) {
        _cartList = cartList;

        if (state is ProductLoaded) {
          final current = state as ProductLoaded;
          emit(
            ProductLoaded(
              products: current.products,
              cartList: _cartList,
              hasReachedEnd: current.hasReachedEnd,
              params: current.params,
            ),
          );
        }
      },
    );
  }

  Future<void> applySearch(String query) async {
    final newParams = _currentParams.copyWith(page: 1, search: query);
    await getInitialProducts(params: newParams);
  }

  Future<void> applyFilter({
    String? city,
    String? merchantType,
    String? paymentMethod,
  }) async {
    final newParams = _currentParams.copyWith(
      page: 1,
      city: city,
      merchantType: merchantType,
      paymentMethod: paymentMethod,
    );
    await getInitialProducts(params: newParams);
  }

  Future<void> resetFilterAndSearch() async {
    await getInitialProducts(params: const ProductQueryParams(page: 1));
  }
}
