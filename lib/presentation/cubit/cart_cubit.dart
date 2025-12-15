import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/params/update_chart_params.dart';
import '../../domain/entities/chart_entity.dart';
import '../../domain/usecase/delete_chart.dart';
import '../../domain/usecase/get_list_chart.dart';
import '../../domain/usecase/update_chart.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetListChart getListChart;
  final DeleteChart deleteChart;
  final UpdateChart updateChart;

  CartCubit({
    required this.getListChart,
    required this.deleteChart,
    required this.updateChart,
  }) : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());
    final result = await getListChart.execute();
    result.fold(
      (failure) => emit(CartError(failure)),
      (cartList) => emit(CartLoaded(cartList)),
    );
  }

  Future<void> fetchCartNoLoad() async {
    final result = await getListChart.execute();
    result.fold(
      (failure) => emit(CartError(failure)),
      (cartList) => emit(CartLoaded(cartList)),
    );
  }

  Future<void> removeFromCart(int chartId) async {
    final result = await deleteChart.execute(chartId);

    result.fold(
      (failure) async {
        emit(CartActionError(failure));
        await fetchCartNoLoad();
      },
      (successMessage) async {
        emit(CartActionSuccess(successMessage));

        await fetchCartNoLoad();
      },
    );
  }

  Future<void> updateCartItem({
    required int chartId,
    required UpdateChartParams params,
  }) async {
    final result = await updateChart.execute(params: params, id: chartId);

    result.fold(
      (failure) async {
        emit(CartActionError(failure));
        await fetchCartNoLoad();
      },
      (successMessage) async {
        await fetchCartNoLoad();
      },
    );
  }
}
