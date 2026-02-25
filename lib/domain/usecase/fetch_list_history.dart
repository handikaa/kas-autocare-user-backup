import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/history/history_transaction_entity.dart';

import '../../data/params/history_params.dart';
import '../repositories/repositories_domain.dart';

class FetchListHistory {
  final RepositoriesDomain repositoriesDomain;

  FetchListHistory(this.repositoriesDomain);

  Future<Either<String, List<HistoryTransactionEntity>>> execute(
    HistoryParams? params, {
    required int page,
  }) {
    return repositoriesDomain.getListHistory(params, page: page);
  }
}
