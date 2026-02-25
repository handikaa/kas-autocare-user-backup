import 'package:dartz/dartz.dart';

import '../entities/history/history_entity.dart';
import '../repositories/repositories_domain.dart';

class FetchDetailHistory {
  final RepositoriesDomain repositoriesDomain;

  FetchDetailHistory(this.repositoriesDomain);

  Future<Either<String, HistoryEntity>> execute(int id) async {
    return await repositoriesDomain.getDetailHistory(id);
  }
}
