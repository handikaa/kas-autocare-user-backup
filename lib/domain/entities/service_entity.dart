import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String name;
  final String vehicleType;
  final int isWashingType;
  final int estimatedTime;
  final int branchId;
  final int bussinesId;

  final int price;
  final String category;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.isWashingType,
    required this.estimatedTime,
    required this.branchId,
    required this.bussinesId,

    required this.price,
    required this.category,
  });

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
