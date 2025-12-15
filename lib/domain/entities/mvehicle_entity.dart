import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/brand_entity.dart';

class MVehicleEntity extends Equatable {
  final int id;
  final String brandId;
  final String name;
  final String vehicleType;
  final String bodyType;
  final dynamic classType;

  final BrandEntity brand;

  const MVehicleEntity({
    required this.id,
    required this.brandId,
    required this.name,
    required this.vehicleType,
    required this.bodyType,
    required this.classType,

    required this.brand,
  });

  @override
  List<Object?> get props => [
    id,
    brandId,
    name,
    vehicleType,
    bodyType,
    classType,
  ];
}
