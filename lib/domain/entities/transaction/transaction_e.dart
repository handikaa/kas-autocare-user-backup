import 'package:equatable/equatable.dart';

class TransactionE extends Equatable {
  final int userId;
  final int branchId;
  final int bussinesId;
  final dynamic branchEmployeId;
  final int businessUnitId;
  final String licensePlate;
  final String vehicleType;
  final String brand;
  final String model;
  final String color;
  final dynamic image;
  final String status;
  final String code;
  final String ownerName;
  final int totalPrice;
  final dynamic discountId;
  final dynamic membershipId;
  final int finalPrice;
  final dynamic priceMember;
  final int customerId;
  final DateTime scheduleDate;
  final String scheduleTime;
  final bool isKasPlus;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  const TransactionE({
    required this.userId,
    required this.branchId,
    required this.bussinesId,
    required this.branchEmployeId,
    required this.businessUnitId,
    required this.licensePlate,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.color,
    required this.image,
    required this.status,
    required this.code,
    required this.ownerName,
    required this.totalPrice,
    required this.discountId,
    required this.membershipId,
    required this.finalPrice,
    required this.priceMember,
    required this.customerId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.isKasPlus,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

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
