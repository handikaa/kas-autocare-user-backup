import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/core/utils/share_method.dart';
import 'package:kas_autocare_user/data/model/user_model.dart';
import 'package:kas_autocare_user/domain/entities/user_entity.dart';

import '../../domain/entities/chart_entity.dart';
import '../../domain/entities/product_entity.dart';

class ChartModel {
  final int? id;
  final int? branchId;
  final int? bussinesId;
  final int? businessUnitId;
  final int? branchProductNewsId;
  final int? userId;
  final int? customerId;
  final String? productName;
  final String? variantName;
  final String? variantSizeName;
  final List<String>? image;
  final int? qty;
  final int? price;
  final int? totalPrice;
  final String? type;
  final int? variantProductNewsId;
  final int? variantProductSizeNewsId;
  final BranchModel? branch;
  final BranchProductModel? branchProduct;
  final VariantModel? variant;
  final VariantSizeModel? variantSize;
  final UserModel? user;
  final CustomerModel? customer;

  ChartModel({
    this.id,
    this.branchId,
    this.bussinesId,
    this.businessUnitId,
    this.branchProductNewsId,
    this.userId,
    this.customerId,
    this.productName,
    this.variantName,
    this.variantSizeName,
    this.image,
    this.qty,
    this.price,
    this.totalPrice,
    this.type,
    this.variantProductNewsId,
    this.variantProductSizeNewsId,
    this.branch,
    this.branchProduct,
    this.variant,
    this.variantSize,
    this.user,
    this.customer,
  });

  factory ChartModel.fromRawJson(String str) =>
      ChartModel.fromJson(json.decode(str));

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
    id: json["id"],
    branchId: json["branch_id"],
    bussinesId: json["bussines_id"],
    businessUnitId: json["business_unit_id"],
    branchProductNewsId: json["branch_product_news_id"],
    userId: json["user_id"],
    customerId: json["customer_id"],
    productName: json["product_name"],
    variantName: json["variant_name"],
    variantSizeName: json["variant_size_name"],
    image: json["image"] == null
        ? []
        : List<String>.from(json["image"].map((x) => x)),
    qty: json["qty"],
    price: ShareMethod.parseToInt(json["price"]),
    totalPrice: ShareMethod.parseToInt(json["total_price"]),
    type: json["type"],
    variantProductNewsId: json["variant_product_news_id"],
    variantProductSizeNewsId: json["variant_product_size_news_id"],
    branch: json["branch"] != null
        ? BranchModel.fromJson(json["branch"])
        : null,
    branchProduct: json["branch_product"] != null
        ? BranchProductModel.fromJson(json["branch_product"])
        : null,
    variant: json["variant"] != null
        ? VariantModel.fromJson(json["variant"])
        : null,
    variantSize: json["variant_size"] != null
        ? VariantSizeModel.fromJson(json["variant_size"])
        : null,
    user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
    customer: json["customer"] != null
        ? CustomerModel.fromJson(json["customer"])
        : null,
  );

  ChartEntity toEntity() => ChartEntity(
    id: id ?? 0,
    branchId: branchId ?? 0,
    bussinesId: bussinesId ?? 0,
    businessUnitId: businessUnitId ?? 0,
    branchProductNewsId: branchProductNewsId ?? 0,
    userId: userId ?? 0,
    customerId: customerId ?? 0,
    productName: productName ?? '',
    variantName: variantName ?? '',
    variantSizeName: variantSizeName ?? '',
    image: image ?? [],
    qty: qty ?? 0,
    price: price ?? 0,
    totalPrice: totalPrice ?? 0,
    type: type ?? '',
    variantProductNewsId: variantProductNewsId ?? 0,
    variantProductSizeNewsId: variantProductSizeNewsId ?? 0,
    branch:
        branch?.toEntity() ??
        const BranchEntity(
          id: 0,
          name: '',
          address: '',
          ownershipModelId: 0,
          revenueModelId: 0,
          bussinesUnitId: 0,
          chargeFee: 0,
          businessTypeId: 0,
          storeName: '',
          ownerName: '',
          postcode: null,
          province: '',
          city: '',
          district: '',
          bussinesId: 0,
          status: '',
          ward: '',
          pickupPoint: PickupPointEntity(
            address: '',
            id: 0,
            branchId: 0,
            name: '',
            phone: '',
            email: '',
            isMemberDeposit: false,
            pickupPointCode: '',
            originId: 0,
          ),
        ),
    branchProduct:
        branchProduct?.toEntity() ??
        const BranchProductEntity(
          id: 0,
          name: '',
          price: 0,
          image: [],
          stock: 0,
          isCod: false,
          minOrder: 0,
          maxOrder: 0,
        ),
    variant:
        variant?.toEntity() ??
        const VariantEntity(
          id: 0,
          name: '',
          productNewsId: 0,
          branchProductNewsId: 0,
          createdBy: 0,
          sizes: [],
        ),
    variantSize:
        variantSize?.toEntity() ??
        const SizeEntity(
          id: 0,
          size: '',
          price: 0,
          variantProductNewsId: 0,
          productNewsId: 0,
          branchProductNewsId: 0,
          createdBy: 0,
          stock: 0,
        ),
    user:
        user?.toEntity() ??
        UserEntity(
          id: 0,
          name: '',
          email: '',
          username: '',
          phone: '',
          role: '',
          image: '',
        ),
    customer:
        customer?.toEntity() ??
        const CustomerEntity(id: 0, username: '', phone: ''),
  );
}

class BranchModel {
  final int? id;
  final String? name;
  final String? address;
  final PickupPointModel? pickupPointModel;

  BranchModel({this.pickupPointModel, this.id, this.name, this.address});

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    pickupPointModel: json["pickup_points"] != null
        ? PickupPointModel.fromJson(json["pickup_points"])
        : null,
  );

  BranchEntity toEntity() => BranchEntity(
    id: id ?? 0,
    name: name ?? '',
    address: address ?? '',
    ownershipModelId: 0,
    revenueModelId: 0,
    bussinesUnitId: 0,
    chargeFee: 0,
    businessTypeId: 0,
    storeName: '',
    ownerName: '',
    postcode: 0,
    province: '',
    city: '',
    district: '',
    bussinesId: 0,
    status: '',
    ward: '',
    pickupPoint:
        pickupPointModel?.toEntity() ??
        PickupPointEntity(
          id: 0,
          name: '',
          email: '',
          phone: '',
          branchId: 0,
          address: '',
          isMemberDeposit: false,
          pickupPointCode: '',
          originId: 0,
        ),
  );
}

class PickupPointModel extends Equatable {
  final int? id;
  final int? originId;
  final int? branchId;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final bool? isMemberDeposit;
  final String? pickupPointCode;

  PickupPointModel({
    this.originId,
    this.id,
    this.branchId,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.isMemberDeposit,
    this.pickupPointCode,
  });

  factory PickupPointModel.fromRawJson(String str) =>
      PickupPointModel.fromJson(json.decode(str));

  PickupPointEntity toEntity() => PickupPointEntity(
    id: id ?? 0,
    branchId: branchId ?? 0,
    name: name ?? '',
    phone: phone ?? '',
    email: email ?? '',
    address: address ?? '',
    isMemberDeposit: isMemberDeposit ?? false,
    pickupPointCode: pickupPointCode ?? '',
    originId: originId ?? 0,
  );

  factory PickupPointModel.fromJson(Map<String, dynamic> json) =>
      PickupPointModel(
        id: json["id"],
        branchId: json["branch_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        isMemberDeposit: json["is_member_deposit"],
        pickupPointCode: json["pickup_point_code"],
        originId: json["origin_id"],
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    branchId,
    name,
    phone,
    originId,
    email,
    address,
    isMemberDeposit,
    pickupPointCode,
  ];
}

class BranchProductModel {
  final int? id;
  final String? name;
  final int? price;
  final bool? isCod;
  final int? stock;
  final int? minOrder;
  final int? maxOrder;
  final List<String>? image;

  BranchProductModel({
    this.isCod,
    this.stock,
    this.minOrder,
    this.maxOrder,

    this.id,
    this.name,
    this.price,
    this.image,
  });

  factory BranchProductModel.fromJson(Map<String, dynamic> json) =>
      BranchProductModel(
        id: json["id"],
        name: json["name"],
        price: ShareMethod.parseToInt(json["price"]),
        image: json["image"] == null
            ? []
            : List<String>.from(json["image"].map((x) => x)),
        stock: json["qty"],
        minOrder: json["min_order"],
        maxOrder: json["max_order"],
        isCod: json["is_cod"],
      );

  BranchProductEntity toEntity() => BranchProductEntity(
    id: id ?? 0,
    name: name ?? '',
    price: price ?? 0,
    image: image ?? [],
    stock: stock ?? 0,
    isCod: isCod ?? false,
    minOrder: minOrder ?? 0,
    maxOrder: maxOrder ?? 0,
  );
}

class CustomerModel {
  final int? id;
  final String? username;
  final String? phone;

  CustomerModel({this.id, this.username, this.phone});

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json["id"],
    username: json["username"],
    phone: json["phone"],
  );

  CustomerEntity toEntity() =>
      CustomerEntity(id: id ?? 0, username: username ?? '', phone: phone ?? '');
}

// class UserModel {
//   final int? id;
//   final String? name;
//   final String? username;
//   final String? phone;
//   final String? email;

//   UserModel({this.id, this.name, this.email this.username});

//   factory UserModel.fromJson(Map<String, dynamic> json) =>
//       UserModel(id: json["id"], name: json["name"], email: json["email"]);

//   UserEntity toEntity() =>
//       UserEntity(id: id ?? 0, name: name ?? '', email: email ?? '');
// }

class VariantModel {
  final int? id;
  final String? name;

  VariantModel({this.id, this.name});

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      VariantModel(id: json["id"], name: json["name"]);

  VariantEntity toEntity() => VariantEntity(
    id: id ?? 0,
    name: name ?? '',
    productNewsId: 0,
    branchProductNewsId: 0,
    createdBy: 0,
    sizes: [],
  );
}

class VariantSizeModel {
  final int? id;
  final String? size;
  final int? price;
  final int? createdBy;
  final int? stock;

  VariantSizeModel({
    this.createdBy,
    this.stock,
    this.id,
    this.size,
    this.price,
  });

  factory VariantSizeModel.fromJson(Map<String, dynamic> json) =>
      VariantSizeModel(
        id: json["id"],
        size: json["size"],
        price: ShareMethod.parseToInt(json["price"]),
        createdBy: ShareMethod.parseToInt(json["created_by"]),
        stock: ShareMethod.parseToInt(json["qty"]),
      );

  SizeEntity toEntity() => SizeEntity(
    id: id ?? 0,
    size: size ?? '',
    price: price ?? 0,
    variantProductNewsId: 0,
    productNewsId: 0,
    branchProductNewsId: 0,
    createdBy: createdBy ?? 0,
    stock: stock ?? 0,
  );
}
