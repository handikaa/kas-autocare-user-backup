import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/notification/notification_entity.dart';

class NotificationModel extends Equatable {
  final int? id;
  final int? userId;
  final dynamic branchId;
  final dynamic bussinesId;
  final String? deviceToken;
  final String? title;
  final String? message;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? isRead;

  const NotificationModel({
    this.id,
    this.userId,
    this.branchId,
    this.bussinesId,
    this.deviceToken,
    this.title,
    this.message,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.isRead,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["user_id"],
        branchId: json["branch_id"],
        bussinesId: json["bussines_id"],
        deviceToken: json["device_token"],
        title: json["title"],
        message: json["message"],
        type: json["type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        isRead: json["is_read"],
      );

  NotificationEntity toEntity() {
    final now = DateTime.now();
    return NotificationEntity(
      id: id ?? 0,
      userId: userId ?? 0,
      branchId: branchId,
      bussinesId: bussinesId,
      deviceToken: deviceToken ?? '',
      title: title ?? '',
      message: message ?? '',
      type: type ?? '',
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      isRead: isRead ?? 0,
    );
  }

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
