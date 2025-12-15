import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/data/model/brand_model.dart';
import 'package:kas_autocare_user/domain/entities/mvehicle_entity.dart';

import '../../domain/entities/brand_entity.dart';

class MVehicleModel extends Equatable {
  final int? id;
  final String? brandId;
  final String? name;
  final String? vehicleType;
  final String? bodyType;
  final String? classType;

  final BrandModel? brand;

  const MVehicleModel({
    this.id,
    this.brandId,
    this.name,
    this.vehicleType,
    this.bodyType,
    this.classType,
    this.brand,
  });

  MVehicleEntity toEntity() => MVehicleEntity(
    id: id ?? 0,
    brandId: brandId ?? '',
    name: name ?? '',
    vehicleType: vehicleType ?? '',
    bodyType: bodyType ?? '',
    classType: classType,
    brand: brand != null
        ? brand!.toEntity()
        : BrandEntity(id: '', name: '', icon: '', vehicleType: ''),
  );

  factory MVehicleModel.fromRawJson(String str) =>
      MVehicleModel.fromJson(json.decode(str));

  factory MVehicleModel.fromJson(Map<String, dynamic> json) => MVehicleModel(
    id: json["id"],
    brandId: json["brand_id"],
    name: json["name"],
    vehicleType: json["vehicle_type"],
    bodyType: json["body_type"],
    classType: json["class_type"],

    brand: json["brand"] == null ? null : BrandModel.fromJson(json["brand"]),
  );

  @override
  List<Object?> get props => [
    id,
    brand,
    name,
    vehicleType,
    bodyType,
    classType,
    brand,
  ];
}
