import 'package:dartz/dartz.dart';

import '../entities/brand_entity.dart';
import '../repositories/repositories_domain.dart';

class FetchListBrand {
  final RepositoriesDomain repositoriesDomain;

  FetchListBrand(this.repositoriesDomain);

  Future<Either<String, List<BrandEntity>>> execute(String vType) async {
    return await repositoriesDomain.getListBrand(vType);
  }
}
