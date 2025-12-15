import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/vehicle_entity.dart';

class VehicleModel extends Equatable {
  final int? id;
  final String? plateNumber;
  final String? type;
  final String? brand;
  final String? model;
  final String? color;
  final int? userId;

  const VehicleModel({
    this.id,
    this.plateNumber,
    this.type,
    this.brand,
    this.model,
    this.color,
    this.userId,
  });

  factory VehicleModel.fromRawJson(String str) =>
      VehicleModel.fromJson(json.decode(str));

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json["id"],
    plateNumber: json["plate_number"],
    type: json["type"],
    brand: json["brand"],
    model: json["model"],
    color: json["color"],
    userId: json["user_id"],
  );
  VehicleEntity toEntity() => VehicleEntity(
    id: id ?? 0,
    plateNumber: plateNumber ?? '',
    type: type ?? '',
    brand: brand ?? '',
    model: model ?? '',
    color: color ?? '',
    userId: userId ?? 0,
  );

  @override
  List<Object?> get props => [
    id,
    plateNumber,
    type,
    brand,
    model,
    color,
    userId,
  ];
}
