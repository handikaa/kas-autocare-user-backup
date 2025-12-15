import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/brand_entity.dart';

class BrandModel extends Equatable {
  final String? id;
  final String? name;
  final String? icon;
  final String? vehicleType;

  const BrandModel({this.id, this.name, this.icon, this.vehicleType});

  factory BrandModel.fromRawJson(String str) =>
      BrandModel.fromJson(json.decode(str));

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    vehicleType: json["vehicle_type"],
  );

  BrandEntity toEntity() => BrandEntity(
    id: id ?? '',
    name: name ?? '',
    icon: icon ?? '',
    vehicleType: vehicleType ?? '',
  );

  @override
  List<Object?> get props => [id, name, icon, vehicleType];
}
