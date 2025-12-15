import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../domain/entities/shipping_entity.dart';

class CheckShippingModel extends Equatable {
  final List<ShippingModel>? shipping;
  final String? pickupPointCode;
  final int? originId;

  const CheckShippingModel({
    this.shipping,
    this.pickupPointCode,
    this.originId,
  });

  factory CheckShippingModel.fromRawJson(String str) =>
      CheckShippingModel.fromJson(json.decode(str));

  factory CheckShippingModel.fromJson(Map<String, dynamic> json) =>
      CheckShippingModel(
        shipping: json["shipping"] == null
            ? []
            : List<ShippingModel>.from(
                json["shipping"].map((x) => ShippingModel.fromJson(x)),
              ),
        pickupPointCode: json["pickup_point_code"],
        originId: json["origin_id"],
      );

  CheckShippingEntity toEntity() => CheckShippingEntity(
    shipping: shipping?.map((e) => e.toEntity()).toList() ?? [],
    pickupPointCode: pickupPointCode ?? "",
    originId: originId ?? 0,
  );

  @override
  List<Object?> get props => [shipping, pickupPointCode, originId];
}

class ShippingModel extends Equatable {
  final String? courierName;
  final String? courierCode;
  final List<ServiceDetailModel>? serviceDetail;
  final int? insuranceValue;

  const ShippingModel({
    this.courierName,
    this.courierCode,
    this.serviceDetail,
    this.insuranceValue,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) => ShippingModel(
    courierName: json["courier_name"],
    courierCode: json["courier_code"],
    serviceDetail: json["service_detail"] == null
        ? []
        : List<ServiceDetailModel>.from(
            json["service_detail"].map((x) => ServiceDetailModel.fromJson(x)),
          ),
    insuranceValue: json["insurance_value"],
  );

  ShippingEntity toEntity() => ShippingEntity(
    courierName: courierName ?? "",
    courierCode: courierCode ?? "",
    serviceDetail: serviceDetail?.map((e) => e.toEntity()).toList() ?? [],
    insuranceValue: insuranceValue ?? 0,
  );

  @override
  List<Object?> get props => [
    courierName,
    courierCode,
    serviceDetail,
    insuranceValue,
  ];
}

class ServiceDetailModel extends Equatable {
  final String? service;
  final String? serviceGroup;
  final String? serviceCode;
  final String? duration;
  final String? etd;
  final int? price;
  final double? insurance;
  final double? feeCod;
  final bool? isPickup;

  const ServiceDetailModel({
    this.service,
    this.serviceGroup,
    this.serviceCode,
    this.duration,
    this.etd,
    this.price,
    this.insurance,
    this.feeCod,
    this.isPickup,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) =>
      ServiceDetailModel(
        service: json["service"],
        serviceGroup: json["service_group"],
        serviceCode: json["service_code"],
        duration: json["duration"],
        etd: json["etd"],
        price: json["price"],
        insurance: json["insurance"]?.toDouble(),
        feeCod: json["fee_cod"]?.toDouble(),
        isPickup: json["is_pickup"],
      );

  ServiceDetailEntity toEntity() => ServiceDetailEntity(
    service: service ?? "",
    serviceGroup: serviceGroup ?? "",
    serviceCode: serviceCode ?? "",
    duration: duration ?? "",
    etd: etd ?? "",
    price: price ?? 0,
    insurance: insurance ?? 0.0,
    feeCod: feeCod ?? 0.0,
    isPickup: isPickup ?? false,
  );

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
