import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction/users_login_e.dart';

int _intOrZero(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

class UsersLoginM extends Equatable {
  final int? userId;
  final int? branchId;
  final int? bussinesId;
  final int? businessUnitId;
  final int? branchEmployeeId;

  const UsersLoginM({
    this.userId,
    this.branchId,
    this.bussinesId,
    this.businessUnitId,
    this.branchEmployeeId,
  });

  const UsersLoginM.empty()
    : userId = 0,
      branchId = 0,
      bussinesId = 0,
      businessUnitId = 0,
      branchEmployeeId = 0;

  factory UsersLoginM.fromRawJson(String str) =>
      UsersLoginM.fromJson(json.decode(str));

  factory UsersLoginM.fromJson(Map<String, dynamic> json) => UsersLoginM(
    userId: json["user_id"],
    branchId: json["branch_id"],
    bussinesId: json["bussines_id"],
    businessUnitId: json["business_unit_id"],
    branchEmployeeId: json["branch_employee_id"],
  );

  UsersLoginE toEntity() => UsersLoginE(
    userId: _intOrZero(userId),
    branchId: _intOrZero(branchId),
    bussinesId: _intOrZero(bussinesId),
    businessUnitId: _intOrZero(businessUnitId),
    branchEmployeeId: _intOrZero(branchEmployeeId),
  );

  @override
  List<Object?> get props => [
    userId,
    branchId,
    bussinesId,
    businessUnitId,
    branchEmployeeId,
  ];
}
