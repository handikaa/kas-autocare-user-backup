import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/sub_merchant_entity.dart';

class MerchantEntity extends Equatable {
  final int id;
  final int ownershipModelId;
  final int? revenueModelId;
  final int bussinesUnitId;
  final double chargeFee;
  final int? businessTypeId;
  final String name;
  final String storeName;
  final String ownerName;
  final String address;
  final String postcode;
  final int provinceId;
  final int cityId;
  final int merchantType;
  final String merchantCriteria;
  final String merchantCategory;
  final String accountNumber;
  final String accountName;
  final String bankCode;
  final String bankBranch;
  final String urlCallback;
  final String docLocationPath;
  final String province;
  final String city;
  final String district;
  final String pricingType;
  final double latitude;
  final double longitude;
  final int bussinesId;
  final String status;
  final String ward;
  final double distance;
  final StoreStatusEntity storeStatus;
  final SubMerchantEntity subMerchant;

  const MerchantEntity({
    required this.subMerchant,
    required this.storeStatus,
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
    required this.provinceId,
    required this.cityId,
    required this.merchantType,
    required this.merchantCriteria,
    required this.merchantCategory,
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    required this.bankBranch,
    required this.urlCallback,
    required this.docLocationPath,
    required this.province,
    required this.city,
    required this.district,
    required this.pricingType,
    required this.latitude,
    required this.longitude,
    required this.bussinesId,
    required this.status,
    required this.ward,
    required this.distance,
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
    subMerchant,
    district,
    pricingType,
    latitude,
    longitude,
    bussinesId,
    status,
    ward,
    distance,
    storeStatus,
  ];
}

class StoreStatusEntity extends Equatable {
  final bool isOpen;
  final String status;
  final String message;

  const StoreStatusEntity({
    required this.isOpen,
    required this.status,
    required this.message,
  });

  @override
  List<Object?> get props => [isOpen, status, message];
}
