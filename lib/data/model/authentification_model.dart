import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/authentification_entity.dart';

class AuthentificationModel extends Equatable {
  final String? accessToken;
  final String? tokenType;
  final int? userId;
  final String? roles;
  final int? customerId;

  const AuthentificationModel({
    this.accessToken,
    this.tokenType,
    this.userId,
    this.roles,
    this.customerId,
  });

  factory AuthentificationModel.fromRawJson(String str) =>
      AuthentificationModel.fromJson(json.decode(str));

  factory AuthentificationModel.fromJson(Map<String, dynamic> json) =>
      AuthentificationModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        userId: json["user_id"],
        roles: json["roles"],
        customerId: json["customer_id"],
      );

  AuthentificationEntity toEntity() => AuthentificationEntity(
    accessToken: accessToken ?? "",
    tokenType: tokenType ?? "",
    userId: userId ?? 0,
    roles: roles ?? "",
    customerId: customerId ?? 0,
  );

  @override
  List<Object?> get props => [
    accessToken,
    tokenType,
    userId,
    roles,
    customerId,
  ];
}
