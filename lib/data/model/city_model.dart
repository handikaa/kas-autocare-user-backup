import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/city_entity.dart';

class CityModel extends Equatable {
  final int? id;
  final int? provinceId;
  final String? name;
  final ProvinceModel? province;

  const CityModel({this.id, this.provinceId, this.name, this.province});

  factory CityModel.fromRawJson(String str) =>
      CityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json["id"],
    provinceId: json["province_id"],
    name: json["name"],
    province: json["province"] == null
        ? null
        : ProvinceModel.fromJson(json["province"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "province_id": provinceId,
    "name": name,
    "province": province?.toJson(),
  };

  CityEntity toEntity() => CityEntity(
    id: id ?? 0,
    provinceId: provinceId ?? 0,
    name: name ?? '',
    province: province?.toEntity() ?? ProvinceEntity(id: 0, name: ''),
  );

  @override
  List<Object?> get props => [id, provinceId, name, province];
}

class ProvinceModel extends Equatable {
  final int? id;
  final String? name;

  const ProvinceModel({this.id, this.name});

  factory ProvinceModel.fromRawJson(String str) =>
      ProvinceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProvinceModel.fromJson(Map<String, dynamic> json) =>
      ProvinceModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  ProvinceEntity toEntity() => ProvinceEntity(id: id ?? 0, name: name ?? '');

  @override
  List<Object?> get props => [id, name];
}
