import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final int userId;
  final dynamic branchId;
  final dynamic bussinesId;
  final String deviceToken;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isRead;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.bussinesId,
    required this.deviceToken,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    branchId,
    bussinesId,
    deviceToken,
    title,
    message,
    type,
    createdAt,
    updatedAt,
    isRead,
  ];
}
