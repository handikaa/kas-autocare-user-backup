import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/params/add_tochart_params.dart';
import '../../domain/usecase/add_to_chart.dart';

part 'add_tochart_state.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  final AddToChart addToChart;

  AddToCartCubit(this.addToChart) : super(AddToCartInitial());

  Future<void> addToCart(AddChartParams params) async {
    emit(AddToCartLoading());

    final result = await addToChart.execute(params);

    result.fold(
      (error) => emit(AddToCartError(error)),
      (message) => emit(AddToCartSuccess(message)),
    );
  }
}
