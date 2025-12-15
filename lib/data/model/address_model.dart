import 'dart:convert';
import 'package:equatable/equatable.dart';

import '../../domain/entities/address_entity.dart';

class AddressModel extends Equatable {
  final int? id;
  final int? userId;
  final int? customerId;
  final String? provinceName;
  final String? cityName;
  final String? districtName;
  final String? fullAddress;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? districtId;
  final String? name;
  final int? phoneNumber;
  final String? email;

  const AddressModel({
    this.id,
    this.userId,
    this.customerId,
    this.provinceName,
    this.cityName,
    this.districtName,
    this.fullAddress,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.districtId,
    this.name,
    this.phoneNumber,
    this.email,
  });

  factory AddressModel.fromRawJson(String str) =>
      AddressModel.fromJson(json.decode(str));

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"],
    userId: json["user_id"],
    customerId: json["customer_id"],
    provinceName: json["province_name"],
    cityName: json["city_name"],
    districtName: json["district_name"],
    fullAddress: json["full_address"],
    postalCode: json["postal_code"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    isDefault: json["is_default"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
    districtId: json["district_id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
  );

  AddressEntity toEntity() {
    return AddressEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      customerId: customerId ?? 0,
      provinceName: provinceName ?? '',
      cityName: cityName ?? '',
      districtName: districtName ?? '',
      fullAddress: fullAddress ?? '',
      postalCode: postalCode ?? '',
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      isDefault: isDefault ?? false,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      districtId: districtId ?? 0,
      name: name ?? '',
      phoneNumber: phoneNumber ?? 0,
      email: email ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    customerId,
    provinceName,
    cityName,
    districtName,
    fullAddress,
    postalCode,
    latitude,
    longitude,
    isDefault,
    createdAt,
    updatedAt,
    districtId,
    name,
    phoneNumber,
    email,
  ];
}
