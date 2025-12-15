import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int id;
  final int userId;
  final int customerId;
  final String provinceName;
  final String cityName;
  final String districtName;
  final String fullAddress;
  final String postalCode;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int districtId;
  final String name;
  final int phoneNumber;
  final String email;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.customerId,
    required this.provinceName,
    required this.cityName,
    required this.districtName,
    required this.fullAddress,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.districtId,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

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
