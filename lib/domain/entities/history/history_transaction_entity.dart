import 'package:equatable/equatable.dart';

import '../service_entity.dart';

class HistoryTransactionEntity extends Equatable {
  final int id;
  final int userId;
  final int branchId;
  final int businessUnitId;
  final int bussinesId;
  final String licensePlate;
  final String vehicleType;
  final String brand;
  final String model;
  final String color;
  final List<String> image;
  final String code;
  final String status;
  final DateTime cancelledAt;
  final String cancellationReason;
  final DateTime scheduleDate;
  final String scheduleTime;
  final int isKasPlus;
  final String ownerName;
  final int totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int discountId;
  final int finalPrice;
  final int membershipId;
  final int priceMember;
  final int customerId;
  final DateTime date;
  final List<TransactionItemEntity> transactionItems;
  final PaymentEntity payment;
  final BranchEntity branch;
  final ShippingOrderEntity shippingOrder;

  // final MasterMemberEntity masterMember;
  const HistoryTransactionEntity({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.businessUnitId,
    required this.bussinesId,
    required this.licensePlate,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.color,
    required this.image,
    required this.code,
    required this.status,
    required this.cancelledAt,
    required this.cancellationReason,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.isKasPlus,
    required this.ownerName,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.discountId,
    required this.finalPrice,
    required this.membershipId,
    required this.priceMember,
    required this.customerId,
    required this.date,
    required this.transactionItems,
    required this.shippingOrder,
    required this.branch,
    required this.payment,
    // required this.masterMember,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    branchId,
    businessUnitId,
    bussinesId,
    licensePlate,
    vehicleType,
    brand,
    model,
    color,
    image,
    code,
    status,
    cancelledAt,
    cancellationReason,
    scheduleDate,
    scheduleTime,
    isKasPlus,
    ownerName,
    totalPrice,
    createdAt,
    updatedAt,
    discountId,
    finalPrice,
    membershipId,
    priceMember,
    customerId,
    date,
    transactionItems,
    // payment,
    // branch,
    // masterMember,
  ];
}

class MasterMemberEntity extends Equatable {
  final int id;
  final bool isActive;
  final int trxCountMember;
  final int amountMember;
  final int bussinesId;
  final int branchId;
  final int userId;
  final int amountStroke;

  const MasterMemberEntity({
    required this.id,
    required this.isActive,
    required this.trxCountMember,
    required this.amountMember,
    required this.bussinesId,
    required this.branchId,
    required this.userId,
    required this.amountStroke,
  });

  @override
  List<Object?> get props => [
    id,
    isActive,
    trxCountMember,
    amountMember,
    bussinesId,
    branchId,
    userId,
    amountStroke,
  ];
}

class PaymentEntity extends Equatable {
  final int id;
  final String name;
  final int amount;
  final String status;
  final String data;
  final String method;
  final String service;
  final int transactionNewsId;
  final int bussinesId;
  final int branchId;
  final int userId;
  final int customerId;
  final int customersId;
  final int midtransTransactionId;
  final int businessUnitId;

  const PaymentEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.data,
    required this.method,
    required this.service,
    required this.transactionNewsId,
    required this.bussinesId,
    required this.branchId,
    required this.userId,
    required this.customerId,
    required this.customersId,
    required this.midtransTransactionId,
    required this.businessUnitId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    amount,
    status,
    data,
    method,
    service,
    transactionNewsId,
    bussinesId,
    branchId,
    userId,
    customerId,
    customersId,
    midtransTransactionId,
    businessUnitId,
  ];
}

class TransactionItemEntity extends Equatable {
  final int id;
  final int transactionNewsId;
  final int branchProductsId;
  final int branchProductNewsId;
  final int qty;
  final int packagesNewId;
  final int serviceNewsId;
  final int branchesId;
  final int bussinesId;
  final int slotNewsId;
  final int washerId;
  final int checkerId;
  final int isCompliment;
  final String itemType;
  final int estimatedTime;
  final DateTime startTime;
  final DateTime endTime;
  final String size;
  final int priceSize;
  final String facility;
  final int price;
  final String description;
  final List<String> image;
  final int productNewsId;
  final int variantProductNewsId;
  final int variantProductSizeNewsId;
  final int cartId;
  final BranchProductNewsEntity branchProductNews;
  final VariantProductEntity variantProduct;
  final VariantProductSizeEntity variantProductSize;
  final PackageNewEntity packageNew;
  final PackageVariantNewEntity packageVariantNew;
  final ServiceEntity serviceEntity;

  const TransactionItemEntity({
    required this.serviceEntity,
    required this.packageVariantNew,
    required this.packageNew,
    required this.variantProductSize,
    required this.variantProduct,
    required this.branchProductNews,
    required this.id,
    required this.transactionNewsId,
    required this.branchProductsId,
    required this.branchProductNewsId,
    required this.qty,
    required this.packagesNewId,
    required this.serviceNewsId,
    required this.branchesId,
    required this.bussinesId,
    required this.slotNewsId,
    required this.washerId,
    required this.checkerId,
    required this.isCompliment,
    required this.itemType,
    required this.estimatedTime,
    required this.startTime,
    required this.endTime,
    required this.size,
    required this.priceSize,
    required this.facility,
    required this.price,
    required this.description,
    required this.image,

    required this.productNewsId,
    required this.variantProductNewsId,
    required this.variantProductSizeNewsId,
    required this.cartId,
  });

  @override
  List<Object?> get props => [
    id,
    transactionNewsId,
    branchProductsId,
    branchProductNewsId,
    qty,
    packagesNewId,
    serviceNewsId,
    packageNew,
    branchesId,
    bussinesId,
    slotNewsId,
    washerId,
    checkerId,
    isCompliment,
    itemType,
    estimatedTime,
    startTime,
    endTime,
    size,
    priceSize,
    facility,
    price,
    description,
    image,
    productNewsId,
    variantProductNewsId,
    variantProductSizeNewsId,
    cartId,
    packageVariantNew,
    serviceEntity,
    branchProductNews,
    variantProduct,
    variantProductSize,
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
  final String province;
  final String city;
  final String district;

  final int bussinesId;
  final String status;
  final int districtId;

  const BranchEntity({
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
    required this.province,
    required this.city,
    required this.district,

    required this.bussinesId,
    required this.status,
    required this.districtId,
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
    province,
    city,
    district,

    bussinesId,
    status,
    districtId,
  ];
}

class BranchProductNewsEntity extends Equatable {
  final int id;
  final int branchId;
  final int bussinesId;
  final int businessUnitId;
  final String name;
  final int qty;
  final String type;
  final List<String> image;
  final int price;
  final int hpp;
  final bool status;
  final String description;
  final bool isCod;
  final String remarks;
  final int minOrder;
  final int maxOrder;
  final String category;
  final String sku;

  const BranchProductNewsEntity({
    required this.id,
    required this.branchId,
    required this.bussinesId,
    required this.businessUnitId,
    required this.name,
    required this.qty,
    required this.type,
    required this.image,
    required this.price,
    required this.hpp,
    required this.status,
    required this.description,
    required this.isCod,
    required this.remarks,
    required this.minOrder,
    required this.maxOrder,
    required this.category,
    required this.sku,
  });

  @override
  List<Object?> get props => [
    id,
    branchId,
    bussinesId,
    businessUnitId,
    name,
    qty,
    type,
    image,
    price,
    hpp,
    status,
    description,
    isCod,
    remarks,
    minOrder,
    maxOrder,
    category,
    sku,
  ];
}

class VariantProductEntity extends Equatable {
  final int id;
  final int productNewsId;
  final int branchProductNewsId;
  final String name;

  const VariantProductEntity({
    required this.id,
    required this.productNewsId,
    required this.branchProductNewsId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, productNewsId, branchProductNewsId, name];
}

class VariantProductSizeEntity extends Equatable {
  final int id;
  final int variantProductNewsId;
  final String size;
  final int price;
  final int branchProductNewsId;
  final int createdBy;
  final int qty;

  const VariantProductSizeEntity({
    required this.id,
    required this.variantProductNewsId,
    required this.size,
    required this.price,
    required this.branchProductNewsId,
    required this.createdBy,
    required this.qty,
  });

  @override
  List<Object?> get props => [
    id,
    variantProductNewsId,
    size,
    price,
    branchProductNewsId,
    createdBy,
    qty,
  ];
}

class PackageNewEntity extends Equatable {
  final int id;
  final String name;
  final String vehicleType;
  final int isWashingType;
  final int estimatedTime;
  final int branchId;
  final int bussinesId;
  final String description;
  final int price;

  const PackageNewEntity({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.isWashingType,
    required this.estimatedTime,
    required this.branchId,
    required this.bussinesId,
    required this.description,
    required this.price,
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
    description,
    price,
  ];
}

class PackageVariantNewEntity extends Equatable {
  final int id;
  final int packageVariantTypeNewId;
  final int packageNewsId;
  final String size;
  final String facility;
  final int price;
  final int isPrimary;
  final VariantTypeEntity variantType;

  const PackageVariantNewEntity({
    required this.id,
    required this.packageVariantTypeNewId,
    required this.packageNewsId,
    required this.size,
    required this.facility,
    required this.price,
    required this.isPrimary,
    required this.variantType,
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
    variantType,
  ];
}

class VariantTypeEntity extends Equatable {
  final int id;
  final int packageNewsId;
  final String type;

  const VariantTypeEntity({
    required this.id,
    required this.packageNewsId,
    required this.type,
  });

  @override
  List<Object?> get props => [id, packageNewsId, type];
}

class ShippingOrderEntity extends Equatable {
  final int id;
  final int transactionNewsId;
  final int shippingCouriersId;
  final int autokirimOrderId;
  final dynamic trackingNumber;
  final String courierService;
  final String serviceCode;
  final dynamic originName;
  final dynamic originPhone;
  final dynamic originAddress;
  final dynamic originProvinceName;
  final dynamic originCityName;
  final dynamic originDistrictName;
  final dynamic originVillageName;
  final dynamic originPostalCode;
  final String destinationName;
  final String destinationPhone;
  final String destinationAddress;
  final dynamic destinationProvinceName;
  final dynamic destinationCityName;
  final dynamic destinationDistrictName;
  final dynamic destinationVillageName;
  final dynamic destinationPostalCode;
  final int shippingCost;
  final double insuranceCost;
  final String status;
  final String note;
  final dynamic shippedAt;
  final dynamic deliveredAt;

  const ShippingOrderEntity({
    required this.serviceCode,
    required this.id,
    required this.transactionNewsId,
    required this.shippingCouriersId,
    required this.autokirimOrderId,
    required this.trackingNumber,
    required this.courierService,
    required this.originName,
    required this.originPhone,
    required this.originAddress,
    required this.originProvinceName,
    required this.originCityName,
    required this.originDistrictName,
    required this.originVillageName,
    required this.originPostalCode,
    required this.destinationName,
    required this.destinationPhone,
    required this.destinationAddress,
    required this.destinationProvinceName,
    required this.destinationCityName,
    required this.destinationDistrictName,
    required this.destinationVillageName,
    required this.destinationPostalCode,
    required this.shippingCost,
    required this.insuranceCost,
    required this.status,
    required this.note,
    required this.shippedAt,
    required this.deliveredAt,
  });

  @override
  List<Object?> get props => [
    id,
    transactionNewsId,
    shippingCouriersId,
    autokirimOrderId,
    trackingNumber,
    courierService,
    originName,
    originPhone,
    originAddress,
    originProvinceName,
    originCityName,
    originDistrictName,
    originVillageName,
    originPostalCode,
    destinationName,
    destinationPhone,
    destinationAddress,
    destinationProvinceName,
    destinationCityName,
    destinationDistrictName,
    destinationVillageName,
    destinationPostalCode,
    shippingCost,
    insuranceCost,
    status,
    note,
    shippedAt,
    serviceCode,
    deliveredAt,
  ];
}
