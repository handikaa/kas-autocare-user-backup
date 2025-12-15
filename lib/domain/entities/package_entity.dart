import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final int id;
  final String name;
  final String vehicleType;
  final int modelId;
  final int isWashingType;
  final int estimatedTime;
  final int branchId;
  final int bussinesId;
  final String description;
  final int price;
  final String category;
  final MatchedVehicleModelEntity matchedVehicleModel;
  final List<VariantTypeEntity> variantTypes;

  const PackageEntity({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.modelId,
    required this.isWashingType,
    required this.estimatedTime,
    required this.branchId,
    required this.bussinesId,
    required this.description,
    required this.price,
    required this.category,
    required this.matchedVehicleModel,
    required this.variantTypes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    vehicleType,
    modelId,
    isWashingType,
    estimatedTime,
    branchId,
    bussinesId,
    description,
    price,
    category,
    matchedVehicleModel,
    variantTypes,
  ];
}

class MatchedVehicleModelEntity extends Equatable {
  final int id;
  final String name;
  final String brand;
  final String size;
  final String bodyType;
  final String vehicleType;

  const MatchedVehicleModelEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.size,
    required this.bodyType,
    required this.vehicleType,
  });

  @override
  List<Object?> get props => [id, name, brand, size, bodyType, vehicleType];
}

class VariantTypeEntity extends Equatable {
  final int id;
  final int packageNewsId;
  final String type;
  final List<VariantEntity> variants;

  const VariantTypeEntity({
    required this.id,
    required this.packageNewsId,
    required this.type,
    required this.variants,
  });

  @override
  List<Object?> get props => [id, packageNewsId, type, variants];
}

class VariantEntity extends Equatable {
  final int id;
  final int packageVariantTypeNewId;
  final int packageNewsId;
  final String size;
  final String facility;
  final int price;
  final int isPrimary;

  const VariantEntity({
    required this.id,
    required this.packageVariantTypeNewId,
    required this.packageNewsId,
    required this.size,
    required this.facility,
    required this.price,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [
    id,
    packageVariantTypeNewId,
    packageNewsId,
    size,
    facility,
    price,
    isPrimary,
  ];
}
