import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/mvehicle_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchListVmodel {
  final RepositoriesDomain repositoriesDomain;

  FetchListVmodel(this.repositoriesDomain);

  Future<Either<String, List<MVehicleEntity>>> execute({
    required String brand,
    required String vType,
  }) async {
    return await repositoriesDomain.getListModel(brand: brand, vType: vType);
  }
}
