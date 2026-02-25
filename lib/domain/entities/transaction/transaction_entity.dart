import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/transaction/transaction_e.dart';
import 'package:kas_autocare_user/domain/entities/transaction/users_login_e.dart';

class TransactionEntity extends Equatable {
  final UsersLoginE usersLogin;
  final TransactionE transaction;

  const TransactionEntity({
    required this.usersLogin,
    required this.transaction,
  });

  @override
  List<Object?> get props => [usersLogin, transaction];
}
