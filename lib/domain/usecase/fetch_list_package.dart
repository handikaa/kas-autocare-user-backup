import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/package_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchListPackage {
  final RepositoriesDomain repositoriesDomain;

  FetchListPackage(this.repositoriesDomain);

  Future<Either<String, List<PackageEntity>>> execute({
    required int brnchId,
    required int bsnisId,
    required String brand,
    required String model,
    required String vType,
  }) async {
    return await repositoriesDomain.getListPackage(
      brnchId: brnchId,
      bsnisId: bsnisId,
      brand: brand,
      model: model,
      vType: vType,
    );
  }
}
