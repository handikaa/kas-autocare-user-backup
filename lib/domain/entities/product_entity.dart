import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final int branchId;
  final int bussinesId;
  final int businessUnitId;
  final int branchProductNewsId;
  final String name;
  final String productName;
  final String variantName;
  final String variantSizeName;
  final int stock;
  final int totalPrice;
  final String type;
  final List<String> image;
  final int price;
  final int hpp;
  final bool status;
  final String description;
  final int length;
  final int width;
  final int height;
  final int weight;
  final bool isCod;
  final String remarks;
  final int minOrder;
  final int maxOrder;
  final String category;
  final String sku;
  final BranchEntity branch;
  final List<VariantEntity> variants;
  final VariantEntity variantsDetail;
  final VariantSizeDetailEntity variantSizeDetailEntity;

  const ProductEntity({
    required this.variantSizeDetailEntity,
    required this.branchProductNewsId,
    required this.variantsDetail,
    required this.totalPrice,
    required this.productName,
    required this.variantName,
    required this.variantSizeName,
    required this.id,
    required this.branchId,
    required this.bussinesId,
    required this.businessUnitId,
    required this.name,
    required this.stock,
    required this.type,
    required this.image,
    required this.price,
    required this.hpp,
    required this.status,
    required this.description,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.isCod,
    required this.remarks,
    required this.minOrder,
    required this.maxOrder,
    required this.category,
    required this.sku,
    required this.branch,
    required this.variants,
  });

  @override
  List<Object?> get props => [
    id,
    branchId,
    bussinesId,
    businessUnitId,
    name,
    productName,
    variantName,
    variantSizeName,
    totalPrice,
    stock,
    type,
    image,
    price,
    hpp,
    status,
    description,
    length,
    width,
    height,
    weight,
    isCod,
    remarks,
    minOrder,
    maxOrder,
    category,
    sku,
    branch,
    variants,
    variantsDetail,
    variantSizeDetailEntity,
    branchProductNewsId,
  ];
}

class VariantSizeDetailEntity extends Equatable {
  final int id;
  final int variantProductNewsId;
  final String size;
  final int price;

  final int productNewsId;
  final int branchProductNewsId;

  final int qty;

  const VariantSizeDetailEntity({
    required this.id,
    required this.variantProductNewsId,
    required this.size,
    required this.price,

    required this.productNewsId,
    required this.branchProductNewsId,
    required this.qty,
  });

  @override
  List<Object?> get props => [
    id,
    variantProductNewsId,
    size,
    price,
    productNewsId,
    branchProductNewsId,
    qty,
  ];
}

class BranchEntity extends Equatable {
  final int id;
  final int ownershipModelId;
  final int revenueModelId;
  final int bussinesUnitId;
  final int chargeFee;
  final int businessTypeId;
  final String name;
  final String storeName;
  final String ownerName;
  final String address;
  final dynamic postcode;
  final String province;
  final String city;
  final String district;
  final int bussinesId;
  final String status;
  final String ward;
  final PickupPointEntity? pickupPoint;

  const BranchEntity({
    this.pickupPoint,
    required this.id,
    required this.ownershipModelId,
    required this.revenueModelId,
    required this.bussinesUnitId,
    required this.chargeFee,
    required this.businessTypeId,
    required this.name,
    required this.storeName,
    required this.ownerName,
    required this.address,
    required this.postcode,
    required this.province,
    required this.city,
    required this.district,
    required this.bussinesId,
    required this.status,
    required this.ward,
  });

  @override
  List<Object?> get props => [
    id,
    ownershipModelId,
    revenueModelId,
    bussinesUnitId,
    chargeFee,
    businessTypeId,
    name,
    storeName,
    ownerName,
    address,
    postcode,
    province,
    city,
    district,
    bussinesId,
    status,
    ward,
    pickupPoint,
  ];
}

class PickupPointEntity extends Equatable {
  final int id;
  final int branchId;
  final int originId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final bool isMemberDeposit;
  final String pickupPointCode;

  const PickupPointEntity({
    required this.originId,
    required this.id,
    required this.branchId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.isMemberDeposit,
    required this.pickupPointCode,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    branchId,
    name,
    phone,
    email,
    address,
    isMemberDeposit,
    pickupPointCode,
    originId,
  ];
}

class VariantEntity extends Equatable {
  final int id;
  final int productNewsId;
  final int branchProductNewsId;
  final String name;
  final int createdBy;
  final List<SizeEntity> sizes;

  const VariantEntity({
    required this.id,
    required this.productNewsId,
    required this.branchProductNewsId,
    required this.name,
    required this.createdBy,
    required this.sizes,
  });

  @override
  List<Object?> get props => [
    id,
    productNewsId,
    branchProductNewsId,
    name,
    createdBy,
    sizes,
  ];
}

class SizeEntity extends Equatable {
  final int id;
  final int variantProductNewsId;
  final String size;
  final int price;
  final int productNewsId;
  final int branchProductNewsId;
  final int createdBy;
  final int stock;

  const SizeEntity({
    required this.id,
    required this.variantProductNewsId,
    required this.size,
    required this.price,
    required this.productNewsId,
    required this.branchProductNewsId,
    required this.createdBy,
    required this.stock,
  });

  @override
  List<Object?> get props => [
    id,
    variantProductNewsId,
    size,
    price,
    productNewsId,
    branchProductNewsId,
    createdBy,
    stock,
  ];
}
