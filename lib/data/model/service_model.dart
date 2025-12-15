import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/core/utils/share_method.dart';

import '../../domain/entities/service_entity.dart';

class ServiceModel extends Equatable {
  final int? id;
  final String? name;
  final String? vehicleType;
  final int? isWashingType;
  final int? estimatedTime;
  final int? branchId;
  final int? bussinesId;

  final int? price;
  final String? category;

  const ServiceModel({
    this.id,
    this.name,
    this.vehicleType,
    this.isWashingType,
    this.estimatedTime,
    this.branchId,
    this.bussinesId,
    this.price,
    this.category,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    name: json["name"],
    vehicleType: json["vehicle_type"],
    isWashingType: json["is_washing_type"],
    estimatedTime: json["estimated_time"],
    branchId: ShareMethod.parseToInt(json["branch_id"]),
    bussinesId: ShareMethod.parseToInt(json["bussines_id"]),

    price: json["price"],
    category: json["category"],
  );

  ServiceEntity toEntity() => ServiceEntity(
    id: id ?? 0,
    name: name ?? '',
    vehicleType: vehicleType ?? '',
    isWashingType: isWashingType ?? 0,
    estimatedTime: estimatedTime ?? 0,
    branchId: branchId ?? 0,
    bussinesId: bussinesId ?? 0,

    price: price ?? 0,
    category: category ?? '',
  );

  @override
  List<Object?> get props => [
    id,
    name,
    vehicleType,
    isWashingType,
    estimatedTime,
    branchId,
    bussinesId,

    price,
    category,
  ];
}
