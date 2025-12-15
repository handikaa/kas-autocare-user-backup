import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/vehicle_payload_model.dart';
import '../../domain/usecase/create_vehicle_customer.dart';
import 'create_new_v_state.dart';

class CreateVehicleCubit extends Cubit<CreateVehicleState> {
  final CreateVehicleCustomer createVehicleCustomer;

  CreateVehicleCubit(this.createVehicleCustomer)
    : super(CreateVehicleInitial());

  Future<void> createVehicle(VehiclePayloadModel payload) async {
    emit(CreateVehicleLoading());

    final result = await createVehicleCustomer.execute(payload);

    result.fold(
      (error) => emit(CreateVehicleError(error)),
      (message) => emit(CreateVehicleSuccess(message)),
    );
  }
}
