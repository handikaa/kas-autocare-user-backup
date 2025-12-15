import 'package:dartz/dartz.dart';

import '../../data/params/get_hour_params.dart';
import '../entities/time_entity.dart';
import '../repositories/repositories_domain.dart';

class FetchListTime {
  final RepositoriesDomain repositoriesDomain;

  FetchListTime(this.repositoriesDomain);

  Future<Either<String, List<TimeEntity>>> execute({
    required GetHourParams params,
  }) {
    return repositoriesDomain.getListTime(params: params);
  }
}
