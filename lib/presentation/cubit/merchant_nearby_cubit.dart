import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/merchant_entity.dart';

import '../../data/model/params_location.dart';
import '../../domain/usecase/fetch_list_merchant_nearby.dart';

part 'merchant_nearby_state.dart';

class MerchantNearbyCubit extends Cubit<MerchantNearbyState> {
  final FetchListMerchantNearby fetchListMerchantNearby;

  MerchantNearbyCubit(this.fetchListMerchantNearby)
    : super(MerchantNearbyInitial());

  Future<void> getNearbyMerchants(ParamsLocation params) async {
    emit(MerchantNearbyLoading());

    final result = await fetchListMerchantNearby.execute(params);

    result.fold(
      (failure) => emit(MerchantNearbyError(failure)),
      (merchants) => emit(MerchantNearbyLoaded(merchants)),
    );
  }
}
