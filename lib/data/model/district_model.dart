import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/district_entity.dart';

class DistrictModel extends Equatable {
  final int? id;
  final int? districtId;
  final String? districtName;
  final String? regencyName;
  final String? provinceName;

  const DistrictModel({
    this.id,
    this.districtId,
    this.districtName,
    this.regencyName,
    this.provinceName,
  });

  factory DistrictModel.fromRawJson(String str) =>
      DistrictModel.fromJson(json.decode(str));

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    id: json["id"],
    districtId: json["district_id"],
    districtName: json["district_name"],
    regencyName: json["regency_name"],
    provinceName: json["province_name"],
  );

  DistrictEntity toEntity() => DistrictEntity(
    id: id ?? 0,
    districtId: districtId ?? 0,
    districtName: districtName ?? '',
    regencyName: regencyName ?? '',
    provinceName: provinceName ?? '',
  );

  @override
  List<Object?> get props => [
    id,
    districtId,
    districtName,
    regencyName,
    provinceName,
  ];
}
