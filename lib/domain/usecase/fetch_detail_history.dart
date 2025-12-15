import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/history_transaction_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchDetailHistory {
  final RepositoriesDomain repositoriesDomain;

  FetchDetailHistory(this.repositoriesDomain);

  Future<Either<String, HistoryTransactionEntity>> execute(int id) async {
    return await repositoriesDomain.getDetailHistory(id);
  }
}
