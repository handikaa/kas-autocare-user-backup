import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/data/params/payload_address_input.dart';
import 'package:kas_autocare_user/domain/entities/address_entity.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_detail_address.dart';
import 'package:kas_autocare_user/domain/usecase/update_address.dart';

import '../../domain/usecase/add_address.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final AddAddress addAddress;
  final FetchDetailAddress fetchDetailAddress;
  final UpdateAddress updateAddress;

  AddAddressCubit(this.addAddress, this.fetchDetailAddress, this.updateAddress)
    : super(AddressInitial());

  Future<void> createNewAddress(PayloadAddressInput payload) async {
    emit(AddressLoading());
    final result = await addAddress.execute(payload);

    result.fold((l) => emit(AddressError(l)), (r) => emit(AddressLoaded(r)));
  }

  Future<void> addressUpdate({
    required PayloadAddressInput payload,
    required int id,
  }) async {
    emit(AddressLoading());
    final result = await updateAddress.execute(payload: payload, id: id);

    result.fold((l) => emit(AddressError(l)), (r) => emit(AddressLoaded(r)));
  }

  Future<void> getDetailAddress(int id) async {
    emit(DetailAddressLoading());
    final result = await fetchDetailAddress.execute(id);

    result.fold(
      (l) => emit(DetailAddressError(l)),
      (r) => emit(DetailAddressLoaded(r)),
    );
  }
}
