import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart' show UserEntity;

class UserModel extends Equatable {
  final int? id;
  final String? name;
  final String? username;
  final String? phone;
  final String? email;
  final String? role;
  final String? image;

  UserModel({
    this.id,
    this.name,
    this.username,
    this.phone,
    this.email,
    this.role,
    this.image,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    phone: json["phone"],
    email: json["email"],
    role: json["role"],
    image: json["image"],
  );

  UserEntity toEntity() => UserEntity(
    id: id ?? 0,
    name: name ?? '',
    email: email ?? '',
    username: username ?? '',
    phone: phone ?? '',
    role: role ?? '',
    image: image ?? '',
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, username, phone, email, role, image];
}
