// To parse this JSON data, do
//
//     final payloadAddressInput = payloadAddressInputFromJson(jsonString);

import 'dart:convert';

String payloadAddressInputToJson(PayloadAddressInput data) =>
    json.encode(data.toJson());

class PayloadAddressInput {
  final int? userId;
  final int? districtId;
  final String? name;
  final String? email;
  final int? phoneNumber;
  final String? fullAddress;
  final String? postalCode;
  final String? latitude;
  final String? longitude;
  final bool? isDefault;

  PayloadAddressInput({
    this.userId,
    this.districtId,
    this.name,
    this.email,
    this.phoneNumber,
    this.fullAddress,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault,
  });

  PayloadAddressInput copyWith({
    int? userId,
    int? districtId,
    String? name,
    String? email,
    int? phoneNumber,
    String? fullAddress,
    String? postalCode,
    String? latitude,
    String? longitude,
    bool? isDefault,
  }) => PayloadAddressInput(
    userId: userId ?? this.userId,
    districtId: districtId ?? this.districtId,
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    fullAddress: fullAddress ?? this.fullAddress,
    postalCode: postalCode ?? this.postalCode,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    isDefault: isDefault ?? this.isDefault,
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "district_id": districtId,

    if (name != null) "name": name,
    if (email != null) "email": email,
    "phone_number": phoneNumber,
    "full_address": fullAddress,
    "postal_code": postalCode,
    if (latitude != null) "latitude": latitude,
    if (longitude != null) "longitude": longitude,
    "is_default": isDefault,
  };
}
