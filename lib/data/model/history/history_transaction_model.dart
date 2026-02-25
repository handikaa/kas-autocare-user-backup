import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/data/model/service_model.dart';
import 'package:kas_autocare_user/domain/entities/service_entity.dart';

import '../../../core/utils/share_method.dart';
import '../../../domain/entities/history/history_transaction_entity.dart';

class HistoryTransactionModel extends Equatable {
  final int? id;
  final int? userId;
  final int? branchId;
  final int? businessUnitId;
  final int? bussinesId;
  final String? licensePlate;
  final String? vehicleType;
  final String? brand;
  final String? model;
  final String? color;
  final List<String>? image;
  final String? code;
  final String? status;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime? scheduleDate;
  final String? scheduleTime;
  final int? isKasPlus;
  final String? ownerName;
  final int? totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? discountId;
  final int? finalPrice;
  final int? membershipId;
  final int? priceMember;
  final int? customerId;
  final DateTime? date;
  final List<TransactionItemModel>? transactionItems;
  final PaymentModel? payment;
  final BranchModel? branchModel;
  final ShippingOrderModel? shippingOrderModel;
  // // final MasterMemberModel? masterMember;

  const HistoryTransactionModel({
    this.id,
    this.userId,
    this.branchId,
    this.businessUnitId,
    this.bussinesId,
    this.licensePlate,
    this.vehicleType,
    this.brand,
    this.model,
    this.color,
    this.image,
    this.code,
    this.status,
    this.cancelledAt,
    this.cancellationReason,
    this.scheduleDate,
    this.scheduleTime,
    this.isKasPlus,
    this.ownerName,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.discountId,
    this.finalPrice,
    this.membershipId,
    this.priceMember,
    this.customerId,
    this.date,
    this.transactionItems,
    this.shippingOrderModel,
    this.branchModel,
    this.payment,
    // this.masterMember,
  });

  factory HistoryTransactionModel.fromJson(Map<String, dynamic> json) =>
      HistoryTransactionModel(
        id: ShareMethod.parseToInt(json["id"]),
        userId: ShareMethod.parseToInt(json["user_id"]),
        branchId: ShareMethod.parseToInt(json["branch_id"]),
        businessUnitId: ShareMethod.parseToInt(json["business_unit_id"]),
        bussinesId: ShareMethod.parseToInt(json["bussines_id"]),
        licensePlate: json["license_plate"],
        vehicleType: json["vehicle_type"],
        brand: json["brand"],
        model: json["model"],
        color: json["color"],
        image: json["image"] == null
            ? []
            : json["image"] is List
            ? List<String>.from(json["image"])
            : [],
        code: json["code"],
        status: json["status"],
        cancelledAt: json["cancelled_at"] == null
            ? null
            : DateTime.parse(json["cancelled_at"]),
        cancellationReason: json["cancellation_reason"],
        scheduleDate: json["schedule_date"] == null
            ? null
            : DateTime.parse(json["schedule_date"]),
        scheduleTime: json["schedule_time"],

        isKasPlus: ShareMethod.parseToInt(json["is_kas_plus"]),
        ownerName: json["owner_name"],
        totalPrice: ShareMethod.parseToInt(json["total_price"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        discountId: ShareMethod.parseToInt(json["discount_id"]),
        finalPrice: ShareMethod.parseToInt(json["final_price"]),
        membershipId: ShareMethod.parseToInt(json["membership_id"]),
        priceMember: ShareMethod.parseToInt(json["price_member"]),
        customerId: ShareMethod.parseToInt(json["customer_id"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        transactionItems: json["transaction_items"] == null
            ? []
            : List<TransactionItemModel>.from(
                json["transaction_items"].map(
                  (x) => TransactionItemModel.fromJson(x),
                ),
              ),
        payment: json["payment"] == null
            ? null
            : PaymentModel.fromJson(json["payment"]),

        branchModel: json["branch"] == null
            ? null
            : BranchModel.fromJson(json["branch"]),
        shippingOrderModel: json["shipping_order"] == null
            ? null
            : ShippingOrderModel.fromJson(json["shipping_order"]),
        // masterMember: json["master_member"] == null
        //     ? null
        //     : MasterMemberModel.fromJson(json["master_member"]),
      );

  HistoryTransactionEntity toEntity() => HistoryTransactionEntity(
    id: id ?? 0,
    userId: userId ?? 0,
    branchId: branchId ?? 0,
    businessUnitId: businessUnitId ?? 0,
    bussinesId: bussinesId ?? 0,
    licensePlate: licensePlate ?? "",
    vehicleType: vehicleType ?? "",
    brand: brand ?? "",
    model: model ?? "",
    color: color ?? "",
    image: image ?? [],
    code: code ?? "",
    status: status ?? "",
    cancelledAt: cancelledAt ?? DateTime.now(),
    cancellationReason: cancellationReason ?? "",
    scheduleDate: scheduleDate ?? DateTime.now(),
    scheduleTime: scheduleTime ?? "",
    isKasPlus: isKasPlus ?? 0,
    ownerName: ownerName ?? "-",
    totalPrice: totalPrice ?? 0,
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? DateTime.now(),
    discountId: discountId ?? 0,
    finalPrice: finalPrice ?? 0,
    membershipId: membershipId ?? 0,
    priceMember: priceMember ?? 0,
    customerId: customerId ?? 0,
    date: date ?? DateTime.now(),
    transactionItems: (transactionItems ?? [])
        .map((e) => e.toEntity())
        .toList(),
    payment:
        payment?.toEntity() ??
        PaymentEntity(
          id: 0,
          name: "",
          amount: 0,
          status: "",
          data: "",
          method: "",
          service: "",
          transactionNewsId: 0,
          bussinesId: 0,
          branchId: 0,
          userId: 0,
          customerId: 0,
          customersId: 0,
          midtransTransactionId: 0,
          businessUnitId: 0,
        ),
    // masterMember:
    //     masterMember?.toEntity() ??
    //     MasterMemberEntity(
    //       id: 0,
    //       isActive: false,
    //       trxCountMember: 0,
    //       amountMember: 0,
    //       bussinesId: 0,
    //       branchId: 0,
    //       userId: 0,
    //       amountStroke: 0,
    //     ),
    branch:
        branchModel?.toEntity() ??
        BranchEntity(
          id: 0,
          ownershipModelId: 0,
          revenueModelId: 0,
          bussinesUnitId: 0,
          chargeFee: 0,
          businessTypeId: 0,
          name: "",
          storeName: "",
          ownerName: "",
          address: "",
          province: "",
          city: "",
          district: "",

          bussinesId: 0,
          status: "",
          districtId: 0,
        ),
    shippingOrder:
        shippingOrderModel?.toEntity() ??
        ShippingOrderEntity(
          id: 0,
          transactionNewsId: 0,
          shippingCouriersId: 0,
          autokirimOrderId: 0,
          trackingNumber: '',
          courierService: '',
          originName: '',
          originPhone: '',
          originAddress: '',
          originProvinceName: '',
          originCityName: '',
          originDistrictName: '',
          originVillageName: '',
          originPostalCode: '',

          destinationName: '',
          destinationPhone: '',
          destinationAddress: '',

          destinationProvinceName: '',
          destinationCityName: '',
          destinationDistrictName: '',
          destinationVillageName: '',
          destinationPostalCode: '',

          shippingCost: 0,
          insuranceCost: 0,
          status: '',
          note: '',

          shippedAt: '',
          deliveredAt: '',
          serviceCode: '',
        ),
  );

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
    payment,
    // masterMember,
  ];

  const HistoryTransactionModel.empty()
    : id = 0,
      userId = 0,
      branchId = 0,
      businessUnitId = 0,
      bussinesId = 0,
      licensePlate = '',
      vehicleType = '',
      brand = '',
      model = '',
      color = '',
      image = const <String>[],
      code = '',
      status = '',
      cancelledAt = null,
      cancellationReason = '',
      scheduleDate = null,
      scheduleTime = '',
      isKasPlus = 0,
      ownerName = '',
      totalPrice = 0,
      createdAt = null,
      updatedAt = null,
      discountId = 0,
      finalPrice = 0,
      membershipId = 0,
      priceMember = 0,
      customerId = 0,
      date = null,
      transactionItems = const <TransactionItemModel>[],
      payment = const PaymentModel.empty(),
      branchModel = const BranchModel.empty(),
      shippingOrderModel = const ShippingOrderModel.empty();
}

class MasterMemberModel extends Equatable {
  final int? id;
  final bool? isActive;
  final int? trxCountMember;
  final int? amountMember;
  final int? bussinesId;
  final int? branchId;
  final int? userId;

  final int? amountStroke;

  const MasterMemberModel({
    this.id,
    this.isActive,
    this.trxCountMember,
    this.amountMember,
    this.bussinesId,
    this.branchId,
    this.userId,
    this.amountStroke,
  });

  factory MasterMemberModel.fromRawJson(String str) =>
      MasterMemberModel.fromJson(json.decode(str));

  factory MasterMemberModel.fromJson(Map<String, dynamic> json) =>
      MasterMemberModel(
        id: ShareMethod.parseToInt(json["id"]),
        isActive: json["is_active"],
        trxCountMember: ShareMethod.parseToInt(json["trx_count_member"]),
        amountMember: ShareMethod.parseToInt(json["amount_member"]),
        bussinesId: ShareMethod.parseToInt(json["bussines_id"]),
        branchId: ShareMethod.parseToInt(json["branch_id"]),
        userId: ShareMethod.parseToInt(json["user_id"]),

        amountStroke: ShareMethod.parseToInt(json["amount_stroke"]),
      );

  MasterMemberEntity toEntity() => MasterMemberEntity(
    id: id ?? 0,
    isActive: isActive ?? false,
    trxCountMember: trxCountMember ?? 0,
    amountMember: amountMember ?? 0,
    bussinesId: bussinesId ?? 0,
    branchId: branchId ?? 0,
    userId: userId ?? 0,

    amountStroke: amountStroke ?? 0,
  );

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

class PaymentModel extends Equatable {
  final int? id;
  final String? name;
  final int? amount;
  final String? status;
  final String? data;
  final String? method;
  final String? service;
  final int? transactionNewsId;
  final int? bussinesId;
  final int? branchId;
  final int? userId;
  final int? customerId;
  final int? customersId;
  final int? midtransTransactionId;
  final int? businessUnitId;

  const PaymentModel({
    this.id,
    this.name,
    this.amount,
    this.status,
    this.data,
    this.method,
    this.service,
    this.transactionNewsId,
    this.bussinesId,
    this.branchId,
    this.userId,
    this.customerId,
    this.customersId,
    this.midtransTransactionId,
    this.businessUnitId,
  });

  factory PaymentModel.fromRawJson(String str) =>
      PaymentModel.fromJson(json.decode(str));

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: ShareMethod.parseToInt(json["id"]),
    name: json["name"],
    amount: ShareMethod.parseToInt(json["amount"]),
    status: json["status"],
    data: json["data"],
    method: json["method"],
    service: json["service"],
    transactionNewsId: ShareMethod.parseToInt(json["transaction_news_id"]),
    bussinesId: ShareMethod.parseToInt(json["bussines_id"]),
    branchId: ShareMethod.parseToInt(json["branch_id"]),
    userId: ShareMethod.parseToInt(json["user_id"]),
    customerId: ShareMethod.parseToInt(json["customer_id"]),
    customersId: ShareMethod.parseToInt(json["customers_id"]),
    midtransTransactionId: ShareMethod.parseToInt(
      json["midtrans_transaction_id"],
    ),
    businessUnitId: ShareMethod.parseToInt(json["business_unit_id"]),
  );

  PaymentEntity toEntity() => PaymentEntity(
    id: id ?? 0,
    name: name ?? "",
    amount: amount ?? 0,
    status: status ?? "",
    data: data ?? "",
    method: method ?? "",
    service: service ?? "",
    transactionNewsId: transactionNewsId ?? 0,
    bussinesId: bussinesId ?? 0,
    branchId: branchId ?? 0,
    userId: userId ?? 0,
    customerId: customerId ?? 0,
    customersId: customersId ?? 0,
    midtransTransactionId: midtransTransactionId ?? 0,
    businessUnitId: businessUnitId ?? 0,
  );

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

  const PaymentModel.empty()
    : id = 0,
      name = '',
      amount = 0,
      status = '',
      data = '',
      method = '',
      service = '',
      transactionNewsId = 0,
      bussinesId = 0,
      branchId = 0,
      userId = 0,
      customerId = 0,
      customersId = 0,
      midtransTransactionId = 0,
      businessUnitId = 0;
}

class TransactionItemModel extends Equatable {
  final int? id;
  final int? transactionNewsId;
  final int? branchProductsId;
  final int? branchProductNewsId;
  final int? qty;
  final int? packagesNewId;
  final int? serviceNewsId;
  final int? branchesId;
  final int? bussinesId;
  final int? slotNewsId;
  final int? washerId;
  final int? checkerId;
  final int? isCompliment;
  final String? itemType;
  final int? estimatedTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? size;
  final int? priceSize;
  final String? facility;
  final int? price;
  final String? description;
  final List<String>? image;
  final int? productNewsId;
  final int? variantProductNewsId;
  final int? variantProductSizeNewsId;
  final int? cartId;
  final BranchProductNewsModel? branchProductNewsModel;
  final VariantProductModel? variantProductModel;
  final VariantProductSizeModel? variantProductSizeModel;
  final PackageNewModel? packageNewModel;
  final PackageVariantNewModel? packageVariantNewModel;
  final ServiceModel? service;

  const TransactionItemModel({
    this.service,
    this.packageVariantNewModel,
    this.packageNewModel,
    this.variantProductSizeModel,
    this.variantProductModel,
    this.branchProductNewsModel,
    this.id,
    this.transactionNewsId,
    this.branchProductsId,
    this.branchProductNewsId,
    this.qty,
    this.packagesNewId,
    this.serviceNewsId,
    this.branchesId,
    this.bussinesId,
    this.slotNewsId,
    this.washerId,
    this.checkerId,
    this.isCompliment,
    this.itemType,
    this.estimatedTime,
    this.startTime,
    this.endTime,
    this.size,
    this.priceSize,
    this.facility,
    this.price,
    this.description,
    this.image,
    this.productNewsId,
    this.variantProductNewsId,
    this.variantProductSizeNewsId,
    this.cartId,
  });

  factory TransactionItemModel.fromRawJson(String str) =>
      TransactionItemModel.fromJson(json.decode(str));

  factory TransactionItemModel.fromJson(
    Map<String, dynamic> json,
  ) => TransactionItemModel(
    id: ShareMethod.parseToInt(json["id"]),
    transactionNewsId: ShareMethod.parseToInt(json["transaction_news_id"]),
    branchProductsId: ShareMethod.parseToInt(json["branch_products_id"]),
    branchProductNewsId: ShareMethod.parseToInt(json["branch_product_news_id"]),
    qty: ShareMethod.parseToInt(json["qty"]),
    packagesNewId: ShareMethod.parseToInt(json["packages_new_id"]),
    serviceNewsId: ShareMethod.parseToInt(json["service_news_id"]),
    branchesId: ShareMethod.parseToInt(json["branches_id"]),
    bussinesId: ShareMethod.parseToInt(json["bussines_id"]),
    slotNewsId: ShareMethod.parseToInt(json["slot_news_id"]),
    washerId: ShareMethod.parseToInt(json["washer_id"]),
    checkerId: ShareMethod.parseToInt(json["checker_id"]),
    isCompliment: ShareMethod.parseToInt(json["is_compliment"]),
    itemType: json["item_type"],
    estimatedTime: ShareMethod.parseToInt(json["estimated_time"]),
    startTime: json["start_time"] == null
        ? null
        : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    size: json["size"],
    priceSize: ShareMethod.parseToInt(json["price_size"]),
    facility: json["facility"]?.toString(),

    price: ShareMethod.parseToInt(json["price"]),
    description: json["description"],
    image: json["image"] == null
        ? []
        : List<String>.from(json["image"]!.map((x) => x)),
    productNewsId: ShareMethod.parseToInt(json["product_news_id"]),
    variantProductNewsId: ShareMethod.parseToInt(
      json["variant_product_news_id"],
    ),
    variantProductSizeNewsId: ShareMethod.parseToInt(
      json["variant_product_size_news_id"],
    ),
    cartId: ShareMethod.parseToInt(json["cart_id"]),
    variantProductModel: json['variant_product'] == null
        ? null
        : VariantProductModel.fromJson(json['variant_product']),

    variantProductSizeModel: json['variant_product_size'] == null
        ? null
        : VariantProductSizeModel.fromJson(json['variant_product_size']),
    branchProductNewsModel: json['branch_product_news'] == null
        ? null
        : BranchProductNewsModel.fromJson(json['branch_product_news']),
    packageNewModel: json['package_new'] == null
        ? null
        : PackageNewModel.fromJson(json['package_new']),
    packageVariantNewModel: json['package_variant_new'] == null
        ? null
        : PackageVariantNewModel.fromJson(json['package_variant_new']),
    service: json['service_new'] == null
        ? null
        : ServiceModel.fromJson(json['service_new']),
  );

  TransactionItemEntity toEntity() => TransactionItemEntity(
    id: id ?? 0,
    transactionNewsId: transactionNewsId ?? 0,
    branchProductsId: branchProductsId ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    qty: qty ?? 0,
    packagesNewId: packagesNewId ?? 0,
    serviceNewsId: serviceNewsId ?? 0,
    branchesId: branchesId ?? 0,
    bussinesId: bussinesId ?? 0,
    slotNewsId: slotNewsId ?? 0,
    washerId: washerId ?? 0,
    checkerId: checkerId ?? 0,
    isCompliment: isCompliment ?? 0,
    itemType: itemType ?? "-",
    estimatedTime: estimatedTime ?? 0,
    startTime: startTime ?? DateTime.now(),
    endTime: endTime ?? DateTime.now(),
    size: size ?? "-",
    priceSize: priceSize ?? 0,
    facility: facility ?? "-",
    price: price ?? 0,
    description: description ?? "-",
    image: image ?? [],
    productNewsId: productNewsId ?? 0,
    variantProductNewsId: variantProductNewsId ?? 0,
    variantProductSizeNewsId: variantProductSizeNewsId ?? 0,
    cartId: cartId ?? 0,
    branchProductNews:
        branchProductNewsModel?.toEntity() ??
        BranchProductNewsEntity(
          id: 0,
          branchId: 0,
          bussinesId: bussinesId ?? 0,
          businessUnitId: 0,
          name: "",
          qty: 0,
          type: "",
          image: [],
          price: 0,
          hpp: 0,
          status: false,
          description: "",
          isCod: false,
          remarks: "",
          minOrder: 0,
          maxOrder: 0,
          category: "",
          sku: "",
        ),
    variantProduct:
        variantProductModel?.toEntity() ??
        VariantProductEntity(
          id: 0,
          productNewsId: 0,
          branchProductNewsId: 0,
          name: '',
        ),
    variantProductSize:
        variantProductSizeModel?.toEntity() ??
        VariantProductSizeEntity(
          id: 0,
          variantProductNewsId: 0,
          size: '',
          price: 0,
          branchProductNewsId: 0,
          createdBy: 0,
          qty: 0,
        ),
    packageNew:
        packageNewModel?.toEntity() ??
        PackageNewEntity(
          id: 0,
          name: '',
          vehicleType: '',
          isWashingType: 0,
          estimatedTime: 0,
          branchId: 0,
          bussinesId: 0,
          description: '',
          price: 0,
        ),
    packageVariantNew:
        packageVariantNewModel?.toEntity() ??
        PackageVariantNewEntity(
          id: 0,
          packageVariantTypeNewId: 0,
          packageNewsId: 0,
          size: '',
          facility: '',
          price: 0,
          isPrimary: 0,
          variantType: const VariantTypeEntity(
            id: 0,
            packageNewsId: 0,
            type: "",
          ),
        ),
    serviceEntity:
        service?.toEntity() ??
        ServiceEntity(
          id: 0,
          name: '',
          vehicleType: '',
          isWashingType: 0,
          estimatedTime: 0,
          branchId: 0,
          bussinesId: 0,
          price: 0,
          category: '',
        ),
  );

  @override
  List<Object?> get props => [
    id,
    transactionNewsId,
    branchProductsId,
    branchProductNewsId,
    qty,
    packagesNewId,
    serviceNewsId,
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
    packageVariantNewModel,
    facility,
    price,
    description,
    image,
    packageNewModel,
    productNewsId,
    variantProductNewsId,
    variantProductSizeNewsId,
    cartId,
  ];

  const TransactionItemModel.empty()
    : service = const ServiceModel.empty(),
      packageVariantNewModel = const PackageVariantNewModel.empty(),
      packageNewModel = const PackageNewModel.empty(),
      variantProductSizeModel = const VariantProductSizeModel.empty(),
      variantProductModel = const VariantProductModel.empty(),
      branchProductNewsModel = const BranchProductNewsModel.empty(),
      id = 0,
      transactionNewsId = 0,
      branchProductsId = 0,
      branchProductNewsId = 0,
      qty = 0,
      packagesNewId = 0,
      serviceNewsId = 0,
      branchesId = 0,
      bussinesId = 0,
      slotNewsId = 0,
      washerId = 0,
      checkerId = 0,
      isCompliment = 0,
      itemType = '',
      estimatedTime = 0,
      startTime = null,
      endTime = null,
      size = '',
      priceSize = 0,
      facility = '',
      price = 0,
      description = '',
      image = const <String>[],
      productNewsId = 0,
      variantProductNewsId = 0,
      variantProductSizeNewsId = 0,
      cartId = 0;
}

class BranchModel extends Equatable {
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
  final String? province;
  final String? city;
  final String? district;
  final int? bussinesId;
  final String? status;
  final int? districtId;

  const BranchModel({
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
    this.province,
    this.city,
    this.district,
    this.bussinesId,
    this.status,
    this.districtId,
  });

  factory BranchModel.fromRawJson(String str) =>
      BranchModel.fromJson(json.decode(str));

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: ShareMethod.parseToInt(json["id"]),
    ownershipModelId: ShareMethod.parseToInt(json["ownership_model_id"]),
    revenueModelId: ShareMethod.parseToInt(json["revenue_model_id"]),
    bussinesUnitId: ShareMethod.parseToInt(json["bussines_unit_id"]),
    chargeFee: ShareMethod.parseToInt(json["charge_fee"]),
    businessTypeId: ShareMethod.parseToInt(json["business_type_id"]),
    name: json["name"],
    storeName: json["store_name"],
    ownerName: json["owner_name"],
    address: json["address"],
    province: json["province"],
    city: json["city"],
    district: json["district"],

    bussinesId: ShareMethod.parseToInt(json["bussines_id"]),
    status: json["status"],
    districtId: json["district_id"],
  );

  BranchEntity toEntity() => BranchEntity(
    id: id ?? 0,
    ownershipModelId: ownershipModelId ?? 0,
    revenueModelId: revenueModelId ?? 0,
    bussinesUnitId: bussinesUnitId ?? 0,
    chargeFee: chargeFee ?? 0,
    businessTypeId: businessTypeId ?? 0,
    name: name ?? "",
    storeName: storeName ?? "",
    ownerName: ownerName ?? "",
    address: address ?? "",
    province: province ?? "",
    city: city ?? "",
    district: district ?? "",
    bussinesId: bussinesId ?? 0,
    status: status ?? "-",
    districtId: districtId ?? 0,
  );

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

  const BranchModel.empty()
    : id = 0,
      ownershipModelId = 0,
      revenueModelId = 0,
      bussinesUnitId = 0,
      chargeFee = 0,
      businessTypeId = 0,
      name = '',
      storeName = '',
      ownerName = '',
      address = '',
      province = '',
      city = '',
      district = '',
      bussinesId = 0,
      status = '',
      districtId = 0;
}

class BranchProductNewsModel extends Equatable {
  final int? id;
  final int? branchId;
  final int? bussinesId;
  final int? businessUnitId;
  final String? name;
  final int? qty;
  final String? type;
  final List<String>? image;
  final int? price;
  final int? hpp;
  final bool? status;
  final String? description;
  final bool? isCod;
  final String? remarks;
  final int? minOrder;
  final int? maxOrder;
  final String? category;
  final String? sku;

  const BranchProductNewsModel({
    this.id,
    this.branchId,
    this.bussinesId,
    this.businessUnitId,
    this.name,
    this.qty,
    this.type,
    this.image,
    this.price,
    this.hpp,
    this.status,
    this.description,

    this.isCod,
    this.remarks,
    this.minOrder,
    this.maxOrder,
    this.category,
    this.sku,
  });

  factory BranchProductNewsModel.fromRawJson(String str) =>
      BranchProductNewsModel.fromJson(json.decode(str));

  factory BranchProductNewsModel.fromJson(Map<String, dynamic> json) =>
      BranchProductNewsModel(
        id: json["id"],
        branchId: json["branch_id"],
        bussinesId: json["bussines_id"],
        businessUnitId: json["business_unit_id"],
        name: json["name"],
        qty: json["qty"],
        type: json["type"],
        image: json["image"] == null
            ? []
            : List<String>.from(json["image"]!.map((x) => x)),
        price: ShareMethod.parseToInt(json["price"]),
        hpp: ShareMethod.parseToInt(json["hpp"]),
        status: json["status"],
        description: json["description"],
        isCod: json["is_cod"],
        remarks: json["remarks"],
        minOrder: json["min_order"],
        maxOrder: json["max_order"],
        category: json["category"],
        sku: json["sku"],
      );

  BranchProductNewsEntity toEntity() => BranchProductNewsEntity(
    id: id ?? 0,
    branchId: branchId ?? 0,
    bussinesId: bussinesId ?? 0,
    businessUnitId: businessUnitId ?? 0,
    name: name ?? "-",
    qty: qty ?? 0,
    type: type ?? "-",
    image: image ?? [],
    price: price ?? 0,
    hpp: hpp ?? 0,
    status: status ?? false,
    description: description ?? "-",
    isCod: isCod ?? false,
    remarks: remarks ?? "-",
    minOrder: minOrder ?? 0,
    maxOrder: maxOrder ?? 0,
    category: category ?? "-",
    sku: sku ?? "-",
  );

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

  const BranchProductNewsModel.empty()
    : id = 0,
      branchId = 0,
      bussinesId = 0,
      businessUnitId = 0,
      name = '',
      qty = 0,
      type = '',
      image = const <String>[],
      price = 0,
      hpp = 0,
      status = false,
      description = '',
      isCod = false,
      remarks = '',
      minOrder = 0,
      maxOrder = 0,
      category = '',
      sku = '';
}

class VariantProductModel extends Equatable {
  final int? id;
  final int? productNewsId;
  final int? branchProductNewsId;
  final String? name;

  const VariantProductModel({
    this.id,
    this.productNewsId,
    this.branchProductNewsId,
    this.name,
  });

  factory VariantProductModel.fromRawJson(String str) =>
      VariantProductModel.fromJson(json.decode(str));

  factory VariantProductModel.fromJson(Map<String, dynamic> json) =>
      VariantProductModel(
        id: json["id"],
        productNewsId: ShareMethod.parseToInt(json["product_news_id"]),
        branchProductNewsId: json["branch_product_news_id"],
        name: json["name"],
      );

  VariantProductEntity toEntity() => VariantProductEntity(
    id: id ?? 0,
    productNewsId: productNewsId ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    name: name ?? "",
  );

  @override
  List<Object?> get props => [id, productNewsId, branchProductNewsId, name];

  const VariantProductModel.empty()
    : id = 0,
      productNewsId = 0,
      branchProductNewsId = 0,
      name = '';
}

class VariantProductSizeModel extends Equatable {
  final int? id;
  final int? variantProductNewsId;
  final String? size;
  final int? price;
  final int? branchProductNewsId;
  final int? createdBy;
  final int? qty;

  const VariantProductSizeModel({
    this.id,
    this.variantProductNewsId,
    this.size,
    this.price,
    this.branchProductNewsId,
    this.createdBy,
    this.qty,
  });

  factory VariantProductSizeModel.fromRawJson(String str) =>
      VariantProductSizeModel.fromJson(json.decode(str));

  factory VariantProductSizeModel.fromJson(Map<String, dynamic> json) =>
      VariantProductSizeModel(
        id: ShareMethod.parseToInt(json["id"]),
        variantProductNewsId: ShareMethod.parseToInt(
          json["variant_product_news_id"],
        ),
        size: json["size"],
        price: ShareMethod.parseToInt(json["price"]),
        branchProductNewsId: ShareMethod.parseToInt(
          json["branch_product_news_id"],
        ),
        createdBy: ShareMethod.parseToInt(json["created_by"]),
        qty: ShareMethod.parseToInt(json["qty"]),
      );

  VariantProductSizeEntity toEntity() => VariantProductSizeEntity(
    id: id ?? 0,
    variantProductNewsId: variantProductNewsId ?? 0,
    size: size ?? "",
    price: price ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    createdBy: createdBy ?? 0,
    qty: qty ?? 0,
  );

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

  const VariantProductSizeModel.empty()
    : id = 0,
      variantProductNewsId = 0,
      size = '',
      price = 0,
      branchProductNewsId = 0,
      createdBy = 0,
      qty = 0;
}

class PackageNewModel extends Equatable {
  final int? id;
  final String? name;
  final String? vehicleType;
  final int? isWashingType;
  final int? estimatedTime;
  final int? branchId;
  final int? bussinesId;
  final String? description;
  final int? price;

  const PackageNewModel({
    this.id,
    this.name,
    this.vehicleType,
    this.isWashingType,
    this.estimatedTime,
    this.branchId,
    this.bussinesId,
    this.description,
    this.price,
  });

  factory PackageNewModel.fromRawJson(String str) =>
      PackageNewModel.fromJson(json.decode(str));

  factory PackageNewModel.fromJson(Map<String, dynamic> json) =>
      PackageNewModel(
        id: json["id"],
        name: json["name"],
        vehicleType: json["vehicle_type"],
        isWashingType: json["is_washing_type"],
        estimatedTime: json["estimated_time"],
        branchId: json["branch_id"],
        bussinesId: json["bussines_id"],
        description: json["description"],
        price: json["price"],
      );

  PackageNewEntity toEntity() => PackageNewEntity(
    id: id ?? 0,
    name: name ?? "",
    vehicleType: vehicleType ?? "",
    isWashingType: isWashingType ?? 0,
    estimatedTime: estimatedTime ?? 0,
    branchId: branchId ?? 0,
    bussinesId: bussinesId ?? 0,
    description: description ?? "",
    price: price ?? 0,
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
    description,
    price,
  ];

  const PackageNewModel.empty()
    : id = 0,
      name = '',
      vehicleType = '',
      isWashingType = 0,
      estimatedTime = 0,
      branchId = 0,
      bussinesId = 0,
      description = '',
      price = 0;
}

class PackageVariantNewModel extends Equatable {
  final int? id;
  final int? packageVariantTypeNewId;
  final int? packageNewsId;
  final String? size;
  final String? facility;
  final int? price;
  final int? isPrimary;
  final VariantTypeModel? variantType;

  const PackageVariantNewModel({
    this.id,
    this.packageVariantTypeNewId,
    this.packageNewsId,
    this.size,
    this.facility,
    this.price,
    this.isPrimary,
    this.variantType,
  });

  factory PackageVariantNewModel.fromRawJson(String str) =>
      PackageVariantNewModel.fromJson(json.decode(str));

  factory PackageVariantNewModel.fromJson(Map<String, dynamic> json) =>
      PackageVariantNewModel(
        id: json["id"],
        packageVariantTypeNewId: json["package_variant_type_new_id"],
        packageNewsId: json["package_news_id"],
        size: json["size"],
        facility: json["facility"]?.toString(),

        price: json["price"],
        isPrimary: json["is_primary"],
        variantType: json["variant_type"] == null
            ? null
            : VariantTypeModel.fromJson(json["variant_type"]),
      );

  PackageVariantNewEntity toEntity() => PackageVariantNewEntity(
    id: id ?? 0,
    packageVariantTypeNewId: packageVariantTypeNewId ?? 0,
    packageNewsId: packageNewsId ?? 0,
    size: size ?? "",
    facility: facility ?? "",
    price: price ?? 0,
    isPrimary: isPrimary ?? 0,
    variantType:
        variantType?.toEntity() ??
        const VariantTypeEntity(id: 0, packageNewsId: 0, type: ""),
  );

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

  const PackageVariantNewModel.empty()
    : id = 0,
      packageVariantTypeNewId = 0,
      packageNewsId = 0,
      size = '',
      facility = '',
      price = 0,
      isPrimary = 0,
      variantType = const VariantTypeModel.empty();
}

class VariantTypeModel extends Equatable {
  final int? id;
  final int? packageNewsId;
  final String? type;

  const VariantTypeModel({this.id, this.packageNewsId, this.type});

  factory VariantTypeModel.fromRawJson(String str) =>
      VariantTypeModel.fromJson(json.decode(str));

  factory VariantTypeModel.fromJson(Map<String, dynamic> json) =>
      VariantTypeModel(
        id: json["id"],
        packageNewsId: json["package_news_id"],
        type: json["type"],
      );

  VariantTypeEntity toEntity() => VariantTypeEntity(
    id: id ?? 0,
    packageNewsId: packageNewsId ?? 0,
    type: type ?? "",
  );

  @override
  List<Object?> get props => [id, packageNewsId, type];
  const VariantTypeModel.empty() : id = 0, packageNewsId = 0, type = '';
}

class ShippingOrderModel extends Equatable {
  final int? id;
  final int? transactionNewsId;
  final int? shippingCouriersId;
  final int? autokirimOrderId;
  final dynamic trackingNumber;
  final String? courierService;
  final String? serviceCode;
  final dynamic originName;
  final dynamic originPhone;
  final dynamic originAddress;
  final dynamic originProvinceName;
  final dynamic originCityName;
  final dynamic originDistrictName;
  final dynamic originVillageName;
  final dynamic originPostalCode;
  final String? destinationName;
  final String? destinationPhone;
  final String? destinationAddress;
  final dynamic destinationProvinceName;
  final dynamic destinationCityName;
  final dynamic destinationDistrictName;
  final dynamic destinationVillageName;
  final dynamic destinationPostalCode;
  final int? shippingCost;
  final double? insuranceCost;
  final String? status;
  final String? note;
  final dynamic shippedAt;
  final dynamic deliveredAt;

  const ShippingOrderModel({
    this.serviceCode,
    this.id,
    this.transactionNewsId,
    this.shippingCouriersId,
    this.autokirimOrderId,
    this.trackingNumber,
    this.courierService,
    this.originName,
    this.originPhone,
    this.originAddress,
    this.originProvinceName,
    this.originCityName,
    this.originDistrictName,
    this.originVillageName,
    this.originPostalCode,
    this.destinationName,
    this.destinationPhone,
    this.destinationAddress,
    this.destinationProvinceName,
    this.destinationCityName,
    this.destinationDistrictName,
    this.destinationVillageName,
    this.destinationPostalCode,
    this.shippingCost,
    this.insuranceCost,
    this.status,
    this.note,
    this.shippedAt,
    this.deliveredAt,
  });

  factory ShippingOrderModel.fromRawJson(String str) =>
      ShippingOrderModel.fromJson(json.decode(str));

  factory ShippingOrderModel.fromJson(Map<String, dynamic> json) =>
      ShippingOrderModel(
        id: json["id"],
        transactionNewsId: json["transaction_news_id"],
        shippingCouriersId: json["shipping_couriers_id"],
        autokirimOrderId: ShareMethod.parseToInt(json["autokirim_order_id"]),
        trackingNumber: json["tracking_number"],
        courierService: json["courier_service"],
        originName: json["origin_name"],
        originPhone: json["origin_phone"],
        originAddress: json["origin_address"],
        originProvinceName: json["origin_province_name"],
        originCityName: json["origin_city_name"],
        originDistrictName: json["origin_district_name"],
        originVillageName: json["origin_village_name"],
        originPostalCode: json["origin_postal_code"],
        destinationName: json["destination_name"],
        destinationPhone: json["destination_phone"].toString(),
        destinationAddress: json["destination_address"],
        destinationProvinceName: json["destination_province_name"],
        destinationCityName: json["destination_city_name"],
        destinationDistrictName: json["destination_district_name"],
        destinationVillageName: json["destination_village_name"],
        destinationPostalCode: json["destination_postal_code"],
        serviceCode: json["service_code"],
        shippingCost: ShareMethod.parseToInt(json["shipping_cost"]),
        insuranceCost: json["insurance_cost"] == null
            ? 0.0
            : double.tryParse(json["insurance_cost"].toString()) ?? 0.0,

        status: json["status"],
        note: json["note"],
        shippedAt: json["shipped_at"],
        deliveredAt: json["delivered_at"],
      );

  /// 🔥 Convert Model → Entity + nullable handling
  ShippingOrderEntity toEntity() => ShippingOrderEntity(
    id: id ?? 0,
    transactionNewsId: transactionNewsId ?? 0,
    shippingCouriersId: shippingCouriersId ?? 0,
    autokirimOrderId: autokirimOrderId ?? 0,
    trackingNumber: trackingNumber ?? "",
    courierService: courierService ?? "",
    originName: originName ?? "",
    originPhone: originPhone ?? "",
    originAddress: originAddress ?? "",
    originProvinceName: originProvinceName ?? "",
    originCityName: originCityName ?? "",
    originDistrictName: originDistrictName ?? "",
    originVillageName: originVillageName ?? "",
    originPostalCode: originPostalCode ?? "",
    destinationName: destinationName ?? "",
    destinationPhone: destinationPhone ?? "",
    destinationAddress: destinationAddress ?? "",
    destinationProvinceName: destinationProvinceName ?? "",
    destinationCityName: destinationCityName ?? "",
    destinationDistrictName: destinationDistrictName ?? "",
    destinationVillageName: destinationVillageName ?? "",
    destinationPostalCode: destinationPostalCode ?? "",
    shippingCost: shippingCost ?? 0,
    insuranceCost: insuranceCost ?? 0.0,
    status: status ?? "",
    note: note ?? "",
    shippedAt: shippedAt ?? "",
    deliveredAt: deliveredAt ?? "",
    serviceCode: serviceCode ?? '',
  );

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
    deliveredAt,
  ];
  const ShippingOrderModel.empty()
    : serviceCode = '',
      id = 0,
      transactionNewsId = 0,
      shippingCouriersId = 0,
      autokirimOrderId = 0,
      trackingNumber = '',
      courierService = '',
      originName = '',
      originPhone = '',
      originAddress = '',
      originProvinceName = '',
      originCityName = '',
      originDistrictName = '',
      originVillageName = '',
      originPostalCode = '',
      destinationName = '',
      destinationPhone = '',
      destinationAddress = '',
      destinationProvinceName = '',
      destinationCityName = '',
      destinationDistrictName = '',
      destinationVillageName = '',
      destinationPostalCode = '',
      shippingCost = 0,
      insuranceCost = 0.0,
      status = '',
      note = '',
      shippedAt = '',
      deliveredAt = '';
}
