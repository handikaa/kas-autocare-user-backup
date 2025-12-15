import 'package:dartz/dartz.dart';

import '../../data/params/add_tochart_params.dart';
import '../repositories/repositories_domain.dart';

class AddToChart {
  final RepositoriesDomain repositoriesDomain;

  AddToChart(this.repositoriesDomain);

  Future<Either<String, String>> execute(AddChartParams params) async {
    return await repositoriesDomain.addChartProduct(params);
  }
}
