import 'package:dartz/dartz.dart';

import '../../data/params/update_chart_params.dart';
import '../repositories/repositories_domain.dart';

class UpdateChart {
  final RepositoriesDomain repositoriesDomain;

  UpdateChart(this.repositoriesDomain);

  Future<Either<String, String>> execute({
    required UpdateChartParams params,
    required int id,
  }) async {
    return await repositoriesDomain.updateChart(params: params, id: id);
  }
}
