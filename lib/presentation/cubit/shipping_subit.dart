import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/data/params/shipping_params.dart';

import '../../domain/entities/shipping_entity.dart';
import '../../domain/usecase/fetch_list_shipping.dart';

part 'shipping_state.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final FetchListShipping fetchListShipping;

  ShippingCubit(this.fetchListShipping) : super(ShippingInitial());

  Future<void> getListShippings(ShippingParams params) async {
    emit(ShippingLoading());

    final result = await fetchListShipping.execute(params);

    result.fold((l) => emit(ShippingError(l)), (r) => emit(ShippingLoaded(r)));
  }
}
