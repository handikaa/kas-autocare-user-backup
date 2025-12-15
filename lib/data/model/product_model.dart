import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/core/utils/share_method.dart';

import '../../domain/entities/product_entity.dart';

class ProductModel extends Equatable {
  final int? id;
  final int? branchId;
  final int? bussinesId;
  final int? businessUnitId;
  final int? branchProductNewsId;
  final String? name;
  final String? productName;
  final String? variantName;
  final String? variantSizeName;
  final int? totalPrice;
  final int? stock;
  final String? type;
  final List<String>? image;
  final int? price;
  final int? hpp;
  final bool? status;
  final String? description;
  final int? length;
  final int? width;
  final int? height;
  final int? weight;
  final bool? isCod;
  final String? remarks;
  final int? minOrder;
  final int? maxOrder;
  final String? category;
  final String? sku;
  final Branch? branch;
  final List<Variant>? variants;
  final Variant? variantDetail;
  final VariantSizeDetailModel? variantSizeDetail;

  const ProductModel({
    this.branchProductNewsId,
    this.variantSizeDetail,
    this.variantDetail,
    this.totalPrice,
    this.variantName,
    this.variantSizeName,
    this.productName,
    this.id,
    this.branchId,
    this.bussinesId,
    this.businessUnitId,
    this.name,
    this.stock,
    this.type,
    this.image,
    this.price,
    this.hpp,
    this.status,
    this.description,
    this.length,
    this.width,
    this.height,
    this.weight,
    this.isCod,
    this.remarks,
    this.minOrder,
    this.maxOrder,
    this.category,
    this.sku,
    this.branch,
    this.variants,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    branchId: json["branch_id"],
    bussinesId: json["bussines_id"],
    businessUnitId: json["business_unit_id"],
    name: json["name"],
    productName: json["product_name"],
    variantName: json["variant_name"],
    variantSizeName: json["variant_size_name"],
    stock: ShareMethod.parseToInt(json["qty"]),
    totalPrice: ShareMethod.parseToInt(json["total_price"]),
    type: json["type"],
    branchProductNewsId: ShareMethod.parseToInt(json['branch_product_news_id']),
    image: json["image"] == null
        ? []
        : List<String>.from(json["image"].map((x) => x)),
    price: ShareMethod.parseToInt(json["price"]),
    hpp: ShareMethod.parseToInt(json["hpp"]),
    status: json["status"],

    description: json["description"],
    length: ShareMethod.parseToInt(json["length"]),
    width: ShareMethod.parseToInt(json["width"]),
    height: ShareMethod.parseToInt(json["height"]),
    weight: ShareMethod.parseToInt(json["weight"]),
    isCod: json["is_cod"],
    remarks: json["remarks"],
    minOrder: ShareMethod.parseToInt(json["min_order"]),
    maxOrder: ShareMethod.parseToInt(json["max_order"]),
    category: json["category"],
    sku: json["sku"],
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),

    variantDetail: json["variant"] == null
        ? null
        : Variant.fromJson(json["variant"]),
    variants: json["variants"] == null
        ? []
        : List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );

  ProductEntity toEntity() => ProductEntity(
    id: id ?? 0,
    branchId: branchId ?? 0,
    bussinesId: bussinesId ?? 0,
    businessUnitId: businessUnitId ?? 0,
    name: name ?? '',
    productName: productName ?? '',
    variantName: variantName ?? '',
    variantSizeName: variantSizeName ?? '',
    totalPrice: totalPrice ?? 0,
    stock: stock ?? 0,
    type: type ?? '',
    image: image ?? [],
    price: price ?? 0,
    hpp: hpp ?? 0,
    status: status ?? false,
    description: description ?? '',
    length: length ?? 0,
    width: width ?? 0,
    height: height ?? 0,
    weight: weight ?? 0,
    isCod: isCod ?? false,
    remarks: remarks ?? '',
    minOrder: minOrder ?? 1,
    maxOrder: maxOrder ?? 999,
    category: category ?? '',
    sku: sku ?? '',
    branch: (branch ?? Branch()).toEntity(),
    variants: (variants ?? []).map((e) => e.toEntity()).toList(),
    variantSizeDetailEntity: (variantSizeDetail ?? VariantSizeDetailModel())
        .toEntity(),

    variantsDetail: (variantDetail ?? Variant()).toEntity(),
    branchProductNewsId: branchProductNewsId ?? 0,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    branchId,
    bussinesId,
    variants,
    branchProductNewsId,
  ];
}

class Branch extends Equatable {
  final int? id;
  final int? ownershipModelId;
  final int? revenueModelId;
  final int? bussinesUnitId;
  final int? chargeFee;
  final int? businessTypeId;
  final String? name;
  final String? storeName;
  final String? ownerName;
  final String? address;
  final int? postcode;
  final String? province;
  final String? city;
  final String? district;
  final int? bussinesId;
  final String? status;
  final String? ward;

  const Branch({
    this.id,
    this.ownershipModelId,
    this.revenueModelId,
    this.bussinesUnitId,
    this.chargeFee,
    this.businessTypeId,
    this.name,
    this.storeName,
    this.ownerName,
    this.address,
    this.postcode,
    this.province,
    this.city,
    this.district,
    this.bussinesId,
    this.status,
    this.ward,
  });

  factory Branch.fromRawJson(String str) => Branch.fromJson(json.decode(str));

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    ownershipModelId: ShareMethod.parseToInt(json["ownership_model_id"]),
    revenueModelId: ShareMethod.parseToInt(json["revenue_model_id"]),
    bussinesUnitId: json["bussines_unit_id"],
    chargeFee: ShareMethod.parseToInt(json["charge_fee"]),
    businessTypeId: ShareMethod.parseToInt(json["business_type_id"]),
    name: json["name"],
    storeName: json["store_name"],
    ownerName: json["owner_name"],
    address: json["address"],
    postcode: ShareMethod.parseToInt(json["postcode"]),
    province: json["province"],
    city: json["city"],
    district: json["district"],
    bussinesId: json["bussines_id"],
    status: json["status"],
    ward: json["ward"],
  );

  BranchEntity toEntity() => BranchEntity(
    id: id ?? 0,
    ownershipModelId: ownershipModelId ?? 0,
    revenueModelId: revenueModelId ?? 0,
    bussinesUnitId: bussinesUnitId ?? 0,
    chargeFee: chargeFee ?? 0,
    businessTypeId: businessTypeId ?? 0,
    name: name ?? '',
    storeName: storeName ?? '',
    ownerName: ownerName ?? '',
    address: address ?? '',
    postcode: postcode ?? 0,
    province: province ?? '',
    city: city ?? '',
    district: district ?? '',
    bussinesId: bussinesId ?? 0,
    status: status ?? '',
    ward: ward ?? '',
    pickupPoint: PickupPointEntity(
      id: 0,
      branchId: 0,
      name: '',
      phone: '',
      email: '',
      address: '',
      isMemberDeposit: false,
      pickupPointCode: '',
      originId: 0,
    ),
  );

  @override
  List<Object?> get props => [id, name, city];
}

class Variant extends Equatable {
  final int? id;
  final int? productNewsId;
  final int? branchProductNewsId;
  final String? name;
  final int? createdBy;
  final List<Size>? sizes;

  const Variant({
    this.id,
    this.productNewsId,
    this.branchProductNewsId,
    this.name,
    this.createdBy,
    this.sizes,
  });

  factory Variant.fromRawJson(String str) => Variant.fromJson(json.decode(str));

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    productNewsId: ShareMethod.parseToInt(json["product_news_id"]),
    branchProductNewsId: ShareMethod.parseToInt(json["branch_product_news_id"]),
    name: json["name"],
    createdBy: json["created_by"],
    sizes: json["sizes"] == null
        ? []
        : List<Size>.from(json["sizes"].map((x) => Size.fromJson(x))),
  );

  VariantEntity toEntity() => VariantEntity(
    id: id ?? 0,
    productNewsId: productNewsId ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    name: name ?? '',
    createdBy: createdBy ?? 0,
    sizes: (sizes ?? []).map((e) => e.toEntity()).toList(),
  );

  @override
  List<Object?> get props => [id, name, createdBy];
}

class VariantSizeDetailModel extends Equatable {
  final int? id;
  final int? variantProductNewsId;
  final String? size;
  final int? price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? productNewsId;
  final int? branchProductNewsId;
  final int? createdBy;
  final int? updatedBy;

  final int? qty;

  const VariantSizeDetailModel({
    this.id,
    this.variantProductNewsId,
    this.size,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.productNewsId,
    this.branchProductNewsId,
    this.createdBy,
    this.updatedBy,
    this.qty,
  });

  factory VariantSizeDetailModel.fromRawJson(String str) =>
      VariantSizeDetailModel.fromJson(json.decode(str));

  factory VariantSizeDetailModel.fromJson(Map<String, dynamic> json) =>
      VariantSizeDetailModel(
        id: json["id"],
        variantProductNewsId: json["variant_product_news_id"],
        size: json["size"],
        price: ShareMethod.parseToInt(json["price"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        productNewsId: json["product_news_id"],
        branchProductNewsId: json["branch_product_news_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        qty: json["qty"],
      );

  VariantSizeDetailEntity toEntity() => VariantSizeDetailEntity(
    id: id ?? 0,
    variantProductNewsId: variantProductNewsId ?? 0,
    size: size ?? '',
    price: price ?? 0,
    productNewsId: productNewsId ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    qty: qty ?? 0,
  );

  @override
  List<Object?> get props => [
    id,
    variantProductNewsId,
    size,
    price,
    createdAt,
    updatedAt,
    productNewsId,
    branchProductNewsId,
    createdBy,
    updatedBy,
    qty,
  ];
}

class Size extends Equatable {
  final int? id;
  final int? variantProductNewsId;
  final String? size;
  final int? price;
  final int? productNewsId;
  final int? branchProductNewsId;
  final int? createdBy;
  final int? stock;

  const Size({
    this.id,
    this.variantProductNewsId,
    this.size,
    this.price,
    this.productNewsId,
    this.branchProductNewsId,
    this.createdBy,
    this.stock,
  });

  factory Size.fromRawJson(String str) => Size.fromJson(json.decode(str));

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    id: json["id"],
    variantProductNewsId: ShareMethod.parseToInt(
      json["variant_product_news_id"],
    ),
    size: json["size"],
    price: ShareMethod.parseToInt(json["price"]),
    productNewsId: json["product_news_id"],
    branchProductNewsId: json["branch_product_news_id"],
    createdBy: json["created_by"],
    stock: json["qty"],
  );

  SizeEntity toEntity() => SizeEntity(
    id: id ?? 0,
    variantProductNewsId: variantProductNewsId ?? 0,
    size: size ?? '',
    price: price ?? 0,
    productNewsId: productNewsId ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    createdBy: createdBy ?? 0,
    stock: stock ?? 0,
  );

  @override
  List<Object?> get props => [id, size, price];
}
