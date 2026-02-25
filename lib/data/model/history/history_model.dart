import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../domain/entities/history/history_entity.dart';
import '../transaction/users_login_m.dart';
import 'history_transaction_model.dart';

class HistoryModel extends Equatable {
  final UsersLoginM? usersLogin;
  final HistoryTransactionModel? transaction;

  const HistoryModel({this.usersLogin, this.transaction});

  factory HistoryModel.fromRawJson(String str) =>
      HistoryModel.fromJson(json.decode(str));

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    usersLogin: json["users"] == null
        ? null
        : UsersLoginM.fromJson(Map<String, dynamic>.from(json["users"])),
    transaction: json["transaction"] == null
        ? null
        : HistoryTransactionModel.fromJson(
            Map<String, dynamic>.from(json["transaction"]),
          ),
  );

  HistoryEntity toEntity() => HistoryEntity(
    usersLogin: (usersLogin ?? const UsersLoginM.empty()).toEntity(),
    historyTransactionEntity:
        (transaction ?? const HistoryTransactionModel.empty()).toEntity(),
  );

  @override
  List<Object?> get props => [usersLogin, transaction];
}
