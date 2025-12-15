import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final int id;
  final String plateNumber;
  final String type;
  final String brand;
  final String model;
  final String color;
  final int userId;

  const VehicleEntity({
    required this.id,
    required this.plateNumber,
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
    required this.userId,
  });

  @override
  List<Object?> get props => [
    id,
    plateNumber,
    type,
    brand,
    model,
    color,
    userId,
  ];
}
