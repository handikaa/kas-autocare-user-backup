import 'package:equatable/equatable.dart';

class UsersLoginE extends Equatable {
  final int userId;
  final int branchId;
  final int bussinesId;
  final int businessUnitId;
  final int branchEmployeeId;

  const UsersLoginE({
    required this.userId,
    required this.branchId,
    required this.bussinesId,
    required this.businessUnitId,
    required this.branchEmployeeId,
  });

  @override
  List<Object?> get props => [
    userId,
    branchId,
    bussinesId,
    businessUnitId,
    branchEmployeeId,
  ];
}
