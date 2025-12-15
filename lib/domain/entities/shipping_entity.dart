import 'package:equatable/equatable.dart';

class CheckShippingEntity extends Equatable {
  final List<ShippingEntity> shipping;
  final String pickupPointCode;
  final int originId;

  const CheckShippingEntity({
    required this.shipping,
    required this.pickupPointCode,
    required this.originId,
  });

  @override
  List<Object?> get props => [shipping, pickupPointCode, originId];
}

class ShippingEntity extends Equatable {
  final String courierName;
  final String courierCode;
  final List<ServiceDetailEntity> serviceDetail;
  final int insuranceValue;

  const ShippingEntity({
    required this.courierName,
    required this.courierCode,
    required this.serviceDetail,
    required this.insuranceValue,
  });

  @override
  List<Object?> get props => [
    courierName,
    courierCode,
    serviceDetail,
    insuranceValue,
  ];
}

class ServiceDetailEntity extends Equatable {
  final String service;
  final String serviceGroup;
  final String serviceCode;
  final String duration;
  final String etd;
  final int price;
  final double insurance;
  final double feeCod;
  final bool isPickup;

  const ServiceDetailEntity({
    required this.service,
    required this.serviceGroup,
    required this.serviceCode,
    required this.duration,
    required this.etd,
    required this.price,
    required this.insurance,
    required this.feeCod,
    required this.isPickup,
  });

  @override
  List<Object?> get props => [
    service,
    serviceGroup,
    serviceCode,
    duration,
    etd,
    price,
    insurance,
    feeCod,
    isPickup,
  ];
}
