// To parse this JSON data, do
//
//     final loginParams = loginParamsFromJson(jsonString);

import 'dart:convert';

String loginParamsToJson(LoginParams data) => json.encode(data.toJson());

class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
