import 'package:dartz/dartz.dart';

import '../entities/chart_entity.dart';
import '../repositories/repositories_domain.dart';

class GetListChart {
  final RepositoriesDomain repositoriesDomain;

  GetListChart(this.repositoriesDomain);

  Future<Either<String, List<ChartEntity>>> execute() async {
    return await repositoriesDomain.getListChart();
  }
}
