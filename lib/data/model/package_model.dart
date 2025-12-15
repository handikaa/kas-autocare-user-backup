import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/package_entity.dart';

class PackageModel extends Equatable {
  final int? id;
  final String? name;
  final String? vehicleType;
  final int? modelId;
  final int? isWashingType;
  final int? estimatedTime;
  final int? branchId;
  final int? bussinesId;
  final String? description;
  final int? price;
  final String? category;
  final MatchedVehicleModelModel? matchedVehicleModel;
  final List<VariantTypeModel>? variantTypes;

  const PackageModel({
    this.id,
    this.name,
    this.vehicleType,
    this.modelId,
    this.isWashingType,
    this.estimatedTime,
    this.branchId,
    this.bussinesId,
    this.description,
    this.price,
    this.category,
    this.matchedVehicleModel,
    this.variantTypes,
  });

  factory PackageModel.fromRawJson(String str) =>
      PackageModel.fromJson(json.decode(str));

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json["id"],
    name: json["name"],
    vehicleType: json["vehicle_type"],
    modelId: json["model_id"],
    isWashingType: json["is_washing_type"],
    estimatedTime: json["estimated_time"],
    branchId: json["branch_id"],
    bussinesId: json["bussines_id"],
    description: json["description"],
    price: json["price"],
    category: json["category"],
    matchedVehicleModel: json["matched_vehicle_model"] == null
        ? null
        : MatchedVehicleModelModel.fromJson(json["matched_vehicle_model"]),
    variantTypes: json["variant_types"] == null
        ? []
        : List<VariantTypeModel>.from(
            json["variant_types"].map((x) => VariantTypeModel.fromJson(x)),
          ),
  );

  PackageEntity toEntity() {
    return PackageEntity(
      id: id ?? 0,
      name: name ?? "",
      vehicleType: vehicleType ?? "",
      modelId: modelId ?? 0,
      isWashingType: isWashingType ?? 0,
      estimatedTime: estimatedTime ?? 0,
      branchId: branchId ?? 0,
      bussinesId: bussinesId ?? 0,
      description: description ?? "",
      price: price ?? 0,
      category: category ?? "",
      matchedVehicleModel:
          matchedVehicleModel?.toEntity() ??
          const MatchedVehicleModelEntity(
            id: 0,
            name: "",
            brand: "",
            size: "",
            bodyType: "",
            vehicleType: "",
          ),
      variantTypes: variantTypes?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

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

class MatchedVehicleModelModel extends Equatable {
  final int? id;
  final String? name;
  final String? brand;
  final String? size;
  final String? bodyType;
  final String? vehicleType;

  const MatchedVehicleModelModel({
    this.id,
    this.name,
    this.brand,
    this.size,
    this.bodyType,
    this.vehicleType,
  });

  factory MatchedVehicleModelModel.fromJson(Map<String, dynamic> json) =>
      MatchedVehicleModelModel(
        id: json["id"],
        name: json["name"],
        brand: json["brand"],
        size: json["size"],
        bodyType: json["body_type"],
        vehicleType: json["vehicle_type"],
      );

  MatchedVehicleModelEntity toEntity() {
    return MatchedVehicleModelEntity(
      id: id ?? 0,
      name: name ?? "",
      brand: brand ?? "",
      size: size ?? "",
      bodyType: bodyType ?? "",
      vehicleType: vehicleType ?? "",
    );
  }

  @override
  List<Object?> get props => [id, name, brand, size, bodyType, vehicleType];
}

class VariantTypeModel extends Equatable {
  final int? id;
  final int? packageNewsId;
  final String? type;
  final List<VariantModel>? variants;

  const VariantTypeModel({
    this.id,
    this.packageNewsId,
    this.type,
    this.variants,
  });

  factory VariantTypeModel.fromJson(Map<String, dynamic> json) =>
      VariantTypeModel(
        id: json["id"],
        packageNewsId: json["package_news_id"],
        type: json["type"],
        variants: json["variants"] == null
            ? []
            : List<VariantModel>.from(
                json["variants"].map((x) => VariantModel.fromJson(x)),
              ),
      );

  VariantTypeEntity toEntity() {
    return VariantTypeEntity(
      id: id ?? 0,
      packageNewsId: packageNewsId ?? 0,
      type: type ?? "",
      variants: variants?.map((e) => e.toEntity()).toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [id, packageNewsId, type, variants];
}

class VariantModel extends Equatable {
  final int? id;
  final int? packageVariantTypeNewId;
  final int? packageNewsId;
  final String? size;
  final String? facility;
  final int? price;
  final int? isPrimary;

  const VariantModel({
    this.id,
    this.packageVariantTypeNewId,
    this.packageNewsId,
    this.size,
    this.facility,
    this.price,
    this.isPrimary,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) => VariantModel(
    id: json["id"],
    packageVariantTypeNewId: json["package_variant_type_new_id"],
    packageNewsId: json["package_news_id"],
    size: json["size"],
    facility: json["facility"],
    price: json["price"],
    isPrimary: json["is_primary"],
  );

  VariantEntity toEntity() {
    return VariantEntity(
      id: id ?? 0,
      packageVariantTypeNewId: packageVariantTypeNewId ?? 0,
      packageNewsId: packageNewsId ?? 0,
      size: size ?? "",
      facility: facility ?? "",
      price: price ?? 0,
      isPrimary: isPrimary ?? 0,
    );
  }

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
