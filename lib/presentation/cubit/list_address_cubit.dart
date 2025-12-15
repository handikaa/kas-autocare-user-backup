import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/address_entity.dart';
import 'package:kas_autocare_user/domain/usecase/delete_address.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_address.dart';

part 'list_address_state.dart';

class ListAddressCubit extends Cubit<ListAddressState> {
  final FetchListAddress fetchListAddress;
  final DeleteAddress deleteAddress;
  ListAddressCubit(this.fetchListAddress, this.deleteAddress)
    : super(ListAddressInitial());

  Future<void> getListAddress() async {
    emit(ListAddressLoading());
    final result = await fetchListAddress.execute();

    result.fold(
      (l) => emit(ListAddressError(l)),
      (r) => emit(ListAddressLoaded(r)),
    );
  }

  Future<void> addressDelete(int id) async {
    emit(DeleteAddressLoading());
    final result = await deleteAddress.execute(id);

    result.fold((l) => emit(DeleteAddressError(l)), (r) {
      emit(DeleteAddressLoaded(r));

      getListAddress();
    });
  }
}
