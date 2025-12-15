import 'package:dartz/dartz.dart';

import '../../data/model/vehicle_payload_model.dart';
import '../repositories/repositories_domain.dart';

class CreateVehicleCustomer {
  final RepositoriesDomain repositoriesDomain;

  CreateVehicleCustomer(this.repositoriesDomain);

  Future<Either<String, String>> execute(VehiclePayloadModel payload) async {
    return await repositoriesDomain.createVehicleRepoImpl(payload);
  }
}
