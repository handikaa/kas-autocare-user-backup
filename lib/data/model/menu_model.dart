import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/menu_entity.dart';

class MenuModel extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? icon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MenuModel({
    this.id,
    this.name,
    this.code,
    this.icon,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuModel.fromRawJson(String str) =>
      MenuModel.fromJson(json.decode(str));

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    icon: json["icon"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  MenuEntity toEntity() => MenuEntity(
    id: id ?? 0,
    name: name ?? '',
    code: code ?? '',
    icon: icon ?? '',
  );
  @override
  List<Object?> get props => [id, name, code, icon, createdAt, updatedAt];
}
