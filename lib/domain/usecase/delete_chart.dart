import 'package:dartz/dartz.dart';

import '../repositories/repositories_domain.dart';

class DeleteChart {
  final RepositoriesDomain repositoriesDomain;

  DeleteChart(this.repositoriesDomain);

  Future<Either<String, String>> execute(int id) async {
    return await repositoriesDomain.deleteChart(id);
  }
}
