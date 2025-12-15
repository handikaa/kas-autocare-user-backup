import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/district_entity.dart';

import '../repositories/repositories_domain.dart';

class GetListDistrict {
  final RepositoriesDomain repositoriesDomain;

  GetListDistrict(this.repositoriesDomain);

  Future<Either<String, List<DistrictEntity>>> execute(String? search) async {
    return await repositoriesDomain.getListDistrict(search);
  }
}
