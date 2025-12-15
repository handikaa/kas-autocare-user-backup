import 'package:dartz/dartz.dart';

import '../entities/city_entity.dart';
import '../repositories/repositories_domain.dart';

class FetchListCity {
  final RepositoriesDomain repositoriesDomain;

  FetchListCity(this.repositoriesDomain);

  Future<Either<String, List<CityEntity>>> fetchListCityt() {
    return repositoriesDomain.getlistCity();
  }
}
