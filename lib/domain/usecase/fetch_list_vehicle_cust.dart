import 'package:dartz/dartz.dart';

import '../entities/vehicle_entity.dart';
import '../repositories/repositories_domain.dart';

class FetchListVehicleCust {
  final RepositoriesDomain repositoriesDomain;

  FetchListVehicleCust(this.repositoriesDomain);

  Future<Either<String, List<VehicleEntity>>> execute() async {
    return await repositoriesDomain.getListVehicle();
  }
}
