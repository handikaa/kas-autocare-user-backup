import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String vehicleType;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.vehicleType,
  });

  @override
  List<Object?> get props => [id, name, icon, vehicleType];
}
