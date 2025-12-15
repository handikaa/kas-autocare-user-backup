import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/service_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchListService {
  final RepositoriesDomain repositoriesDomain;

  FetchListService(this.repositoriesDomain);

  Future<Either<String, List<ServiceEntity>>> execute({
    required int brnchId,
    required int bsnisId,
  }) async {
    return await repositoriesDomain.getListService(
      brnchId: brnchId,
      bsnisId: bsnisId,
    );
  }
}
