import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/data/model/sub_merchant_model.dart';
import 'package:kas_autocare_user/domain/entities/sub_merchant_entity.dart';

import '../../domain/entities/merchant_entity.dart';

class MerchantModel extends Equatable {
  final int? id;
  final int? ownershipModelId;
  final int? revenueModelId;
  final int? bussinesUnitId;
  final double? chargeFee;
  final int? businessTypeId;
  final String? name;
  final String? storeName;
  final String? ownerName;
  final String? address;
  final String? postcode;
  final int? provinceId;
  final int? cityId;
  final int? merchantType;
  final String? merchantCriteria;
  final String? merchantCategory;
  final String? accountNumber;
  final String? accountName;
  final String? bankCode;
  final String? bankBranch;
  final String? urlCallback;
  final String? docLocationPath;
  final String? province;
  final String? city;
  final String? district;
  final String? pricingType;
  final double? latitude;
  final double? longitude;
  final int? bussinesId;
  final String? status;
  final String? ward;
  final double? distance;
  final SubMerchantModel? subMerchant;
  final StoreStatusModel? storeStatus;

  const MerchantModel({
    this.subMerchant,
    this.storeStatus,
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
    this.provinceId,
    this.cityId,
    this.merchantType,
    this.merchantCriteria,
    this.merchantCategory,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankBranch,
    this.urlCallback,
    this.docLocationPath,
    this.province,
    this.city,
    this.district,
    this.pricingType,
    this.latitude,
    this.longitude,
    this.bussinesId,
    this.status,
    this.ward,
    this.distance,
  });

  factory MerchantModel.fromRawJson(String str) =>
      MerchantModel.fromJson(json.decode(str));

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    // helper untuk parsing aman
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      if (v is double) return v.toInt();
      return null;
    }

    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    String? toStr(dynamic v) => v?.toString();

    return MerchantModel(
      id: toInt(json["id"]),
      ownershipModelId: toInt(json["ownership_model_id"]),
      revenueModelId: toInt(json["revenue_model_id"]),
      bussinesUnitId: toInt(json["business_unit_id"]),
      chargeFee: toDouble(json["charge_fee"]),
      businessTypeId: toInt(json["business_type_id"]),
      name: toStr(json["name"]),
      storeName: toStr(json["store_name"]),
      ownerName: toStr(json["owner_name"]),
      address: toStr(json["address"]),
      postcode: toStr(json["postcode"]),
      provinceId: toInt(json["province_id"]),
      cityId: toInt(json["city_id"]),
      merchantType: toInt(json["merchant_type"]),
      merchantCriteria: toStr(json["merchant_criteria"]),
      merchantCategory: toStr(json["merchant_category"]),
      accountNumber: toStr(json["account_number"]),
      accountName: toStr(json["account_name"]),
      bankCode: toStr(json["bank_code"]),
      bankBranch: toStr(json["bank_branch"]),
      urlCallback: toStr(json["url_callback"]),
      docLocationPath: toStr(json["doc_location_path"]),
      province: toStr(json["province"]),
      city: toStr(json["city"]),
      district: toStr(json["district"]),
      pricingType: toStr(json["pricing_type"]),
      latitude: toDouble(json["latitude"]),
      longitude: toDouble(json["longitude"]),
      bussinesId: toInt(json["bussines_id"]),
      status: toStr(json["status"]),
      ward: toStr(json["ward"]),
      distance: toDouble(json["distance"]),
      storeStatus: json["store_status"] == null
          ? null
          : StoreStatusModel.fromJson(json["store_status"]),
      subMerchant: json["sub_merchant"] == null
          ? null
          : SubMerchantModel.fromJson(json["sub_merchant"]),
    );
  }

  MerchantEntity toEntity() => MerchantEntity(
    id: id ?? 0,
    ownershipModelId: ownershipModelId ?? 0,
    revenueModelId: revenueModelId,
    bussinesUnitId: bussinesUnitId ?? 0,
    chargeFee: chargeFee ?? 0.0,
    businessTypeId: businessTypeId,
    name: name ?? '',
    storeName: storeName ?? '',
    ownerName: ownerName ?? '',
    address: address ?? '',
    postcode: postcode ?? '',
    provinceId: provinceId ?? 0,
    cityId: cityId ?? 0,
    merchantType: merchantType ?? 0,
    merchantCriteria: merchantCriteria ?? '',
    merchantCategory: merchantCategory ?? '',
    accountNumber: accountNumber ?? '',
    accountName: accountName ?? '',
    bankCode: bankCode ?? '',
    bankBranch: bankBranch ?? '',
    urlCallback: urlCallback ?? '',
    docLocationPath: docLocationPath ?? '',
    province: province ?? '',
    city: city ?? '',
    district: district ?? '',
    pricingType: pricingType ?? '',
    latitude: latitude ?? 0.0,
    longitude: longitude ?? 0.0,
    bussinesId: bussinesId ?? 0,
    status: status ?? '',
    ward: ward ?? '',
    distance: distance ?? 0.0,
    storeStatus:
        storeStatus?.toEntity() ??
        StoreStatusEntity(isOpen: false, status: '', message: ''),
    subMerchant:
        subMerchant?.toEntity() ?? SubMerchantEntity(id: 0, idMerchant: 0),
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
    postcode,
    provinceId,
    cityId,
    merchantType,
    merchantCriteria,
    merchantCategory,
    accountNumber,
    accountName,
    bankCode,
    bankBranch,
    urlCallback,
    docLocationPath,
    province,
    city,
    district,
    pricingType,
    latitude,
    longitude,
    bussinesId,
    status,
    ward,
    distance,
  ];
}

class StoreStatusModel extends Equatable {
  final bool? isOpen;
  final String? status;
  final String? message;

  const StoreStatusModel({this.isOpen, this.status, this.message});

  factory StoreStatusModel.fromRawJson(String str) =>
      StoreStatusModel.fromJson(json.decode(str));

  factory StoreStatusModel.fromJson(Map<String, dynamic> json) =>
      StoreStatusModel(
        isOpen: json["is_open"],
        status: json["status"],
        message: json["message"],
      );

  StoreStatusEntity toEntity() => StoreStatusEntity(
    isOpen: isOpen ?? false,
    status: status ?? '',
    message: message ?? '',
  );

  @override
  List<Object?> get props => [isOpen, status, message];
}
