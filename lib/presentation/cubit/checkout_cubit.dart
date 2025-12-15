import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/params/checkout_payload.dart';
import '../../domain/usecase/checkout_product.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutProduct checkoutProduct;
  CheckoutCubit(this.checkoutProduct) : super(CheckoutInitial());
  Future<void> checkout(CheckoutPayload payload) async {
    emit(CheckoutLoading());
    final result = await checkoutProduct.checkoutProductt(payload);
    result.fold((l) => emit(CheckoutError(l)), (r) => emit(CheckoutLoaded(r)));
  }
}
