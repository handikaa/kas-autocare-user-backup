import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/data/model/transaction/transaction_m.dart';
import 'package:kas_autocare_user/data/model/transaction/users_login_m.dart';
import 'package:kas_autocare_user/domain/entities/transaction/transaction_entity.dart';

class TransactionModel extends Equatable {
  final UsersLoginM? usersLogin;
  final TransactionM? transaction;

  const TransactionModel({this.usersLogin, this.transaction});

  factory TransactionModel.fromRawJson(String str) =>
      TransactionModel.fromJson(json.decode(str));

  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
  ) => TransactionModel(
    usersLogin: json["users_login"] == null
        ? null
        : UsersLoginM.fromJson(Map<String, dynamic>.from(json["users_login"])),
    transaction: json["transaction"] == null
        ? null
        : TransactionM.fromJson(Map<String, dynamic>.from(json["transaction"])),
  );

  TransactionEntity toEntity() => TransactionEntity(
    usersLogin: (usersLogin ?? const UsersLoginM.empty()).toEntity(),
    transaction: (transaction ?? const TransactionM.empty()).toEntity(),
  );

  @override
  List<Object?> get props => [usersLogin, transaction];
}
