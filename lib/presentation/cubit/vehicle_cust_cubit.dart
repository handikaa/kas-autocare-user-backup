import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/vehicle_entity.dart';
import '../../domain/usecase/fetch_list_vehicle_cust.dart';

part 'vehicle_cust_state.dart';

class VehicleCustCubit extends Cubit<VehicleCustState> {
  final FetchListVehicleCust fetchListVehicleCust;

  VehicleCustCubit(this.fetchListVehicleCust) : super(VehicleInitial());

  Future<void> getListBrand(String vType) async {
    emit(VehicleLoading());
    final result = await fetchListVehicleCust.execute();

    result.fold((l) => emit(VehicleError(l)), (r) => emit(VehicleLoaded(r)));
  }
}
