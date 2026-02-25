import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction/transaction_e.dart';

DateTime _dtOrEpoch(dynamic v) {
  if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString()) ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

bool _boolOrFalse(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  return v.toString().toLowerCase() == 'true';
}

int _intOrZero(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _strOrEmpty(dynamic v) => v?.toString() ?? '';

class TransactionM extends Equatable {
  final int? userId;
  final int? branchId;
  final int? bussinesId;
  final dynamic branchEmployeId;
  final int? businessUnitId;
  final String? licensePlate;
  final String? vehicleType;
  final String? brand;
  final String? model;
  final String? color;
  final dynamic image;
  final String? status;
  final String? code;
  final String? ownerName;
  final int? totalPrice;
  final dynamic discountId;
  final dynamic membershipId;
  final int? finalPrice;
  final dynamic priceMember;
  final int? customerId;
  final DateTime? scheduleDate;
  final String? scheduleTime;
  final bool? isKasPlus;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  const TransactionM({
    this.userId,
    this.branchId,
    this.bussinesId,
    this.branchEmployeId,
    this.businessUnitId,
    this.licensePlate,
    this.vehicleType,
    this.brand,
    this.model,
    this.color,
    this.image,
    this.status,
    this.code,
    this.ownerName,
    this.totalPrice,
    this.discountId,
    this.membershipId,
    this.finalPrice,
    this.priceMember,
    this.customerId,
    this.scheduleDate,
    this.scheduleTime,
    this.isKasPlus,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  const TransactionM.empty()
    : userId = 0,
      branchId = 0,
      bussinesId = 0,
      branchEmployeId = null,
      businessUnitId = 0,
      licensePlate = '',
      vehicleType = '',
      brand = '',
      model = '',
      color = '',
      image = null,
      status = '',
      code = '',
      ownerName = '',
      totalPrice = 0,
      discountId = null,
      membershipId = null,
      finalPrice = 0,
      priceMember = null,
      customerId = 0,
      scheduleDate = null,
      scheduleTime = '',
      isKasPlus = false,
      updatedAt = null,
      createdAt = null,
      id = 0;

  factory TransactionM.fromRawJson(String str) =>
      TransactionM.fromJson(json.decode(str));

  factory TransactionM.fromJson(Map<String, dynamic> json) => TransactionM(
    userId: json["user_id"],
    branchId: json["branch_id"],
    bussinesId: json["bussines_id"],
    branchEmployeId: json["branch_employe_id"], // bisa null
    businessUnitId: json["business_unit_id"],
    licensePlate: json["license_plate"],
    vehicleType: json["vehicle_type"],
    brand: json["brand"],
    model: json["model"],
    color: json["color"],
    image: json["image"],
    status: json["status"],
    code: json["code"],
    ownerName: json["owner_name"],
    totalPrice: json["total_price"],
    discountId: json["discount_id"],
    membershipId: json["membership_id"],
    finalPrice: json["final_price"],
    priceMember: json["price_member"],
    customerId: json["customer_id"],
    scheduleDate: json["schedule_date"] == null
        ? null
        : DateTime.tryParse(json["schedule_date"].toString()),
    scheduleTime: json["schedule_time"],
    isKasPlus: json["is_kas_plus"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"].toString()),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"].toString()),
    id: json["id"],
  );

  TransactionE toEntity() => TransactionE(
    userId: _intOrZero(userId),
    branchId: _intOrZero(branchId),
    bussinesId: _intOrZero(bussinesId),
    branchEmployeId: branchEmployeId, // dynamic boleh tetap
    businessUnitId: _intOrZero(businessUnitId),
    licensePlate: _strOrEmpty(licensePlate),
    vehicleType: _strOrEmpty(vehicleType),
    brand: _strOrEmpty(brand),
    model: _strOrEmpty(model),
    color: _strOrEmpty(color),
    image: image,
    status: _strOrEmpty(status),
    code: _strOrEmpty(code),
    ownerName: _strOrEmpty(ownerName),
    totalPrice: _intOrZero(totalPrice),
    discountId: discountId,
    membershipId: membershipId,
    finalPrice: _intOrZero(finalPrice),
    priceMember: priceMember,
    customerId: _intOrZero(customerId),
    scheduleDate: _dtOrEpoch(scheduleDate),
    scheduleTime: _strOrEmpty(scheduleTime),
    isKasPlus: _boolOrFalse(isKasPlus),
    updatedAt: _dtOrEpoch(updatedAt),
    createdAt: _dtOrEpoch(createdAt),
    id: _intOrZero(id),
  );

  @override
  List<Object?> get props => [
    userId,
    branchId,
    bussinesId,
    branchEmployeId,
    businessUnitId,
    licensePlate,
    vehicleType,
    brand,
    model,
    color,
    image,
    status,
    code,
    ownerName,
    totalPrice,
    discountId,
    membershipId,
    finalPrice,
    priceMember,
    customerId,
    scheduleDate,
    scheduleTime,
    isKasPlus,
    updatedAt,
    createdAt,
    id,
  ];
}
