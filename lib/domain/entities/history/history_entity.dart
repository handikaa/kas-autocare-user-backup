import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/history/history_transaction_entity.dart';
import 'package:kas_autocare_user/domain/entities/transaction/users_login_e.dart';

class HistoryEntity extends Equatable {
  final UsersLoginE usersLogin;
  final HistoryTransactionEntity historyTransactionEntity;

  const HistoryEntity({
    required this.usersLogin,
    required this.historyTransactionEntity,
  });

  @override
  List<Object?> get props => [usersLogin, historyTransactionEntity];
}
