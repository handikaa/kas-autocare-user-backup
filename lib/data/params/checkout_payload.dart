import 'dart:convert';

class CheckoutPayload {
  final int? userId;
  final int? pickupPointId;
  final int? destinationId;
  final int? originId;
  final List<int>? cartIds;
  final Shipping? shipping;

  CheckoutPayload({
    this.destinationId,
    this.originId,
    this.userId,
    this.pickupPointId,
    this.cartIds,
    this.shipping,
  });

  CheckoutPayload copyWith({
    int? userId,
    int? pickupPointId,
    int? destinationId,
    int? originId,
    List<int>? cartIds,
    Shipping? shipping,
  }) => CheckoutPayload(
    userId: userId ?? this.userId,
    pickupPointId: pickupPointId ?? this.pickupPointId,
    cartIds: cartIds ?? this.cartIds,
    shipping: shipping ?? this.shipping,
    originId: originId ?? this.originId,
    destinationId: destinationId ?? this.destinationId,
  );

  factory CheckoutPayload.fromRawJson(String str) =>
      CheckoutPayload.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckoutPayload.fromJson(Map<String, dynamic> json) =>
      CheckoutPayload(
        userId: json["user_id"],
        pickupPointId: json["pickup_point_id"],
        cartIds: json["cart_ids"] == null
            ? []
            : List<int>.from(json["cart_ids"]!.map((x) => x)),
        shipping: json["shipping"] == null
            ? null
            : Shipping.fromJson(json["shipping"]),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "pickup_point_id": pickupPointId,
    "destination_id": destinationId,
    "origin_id": originId,
    "cart_ids": cartIds == null
        ? []
        : List<dynamic>.from(cartIds!.map((x) => x)),
    "shipping": shipping?.toJson(),
  };
}

class Shipping {
  final String? courierCode;
  final String? courierName;
  final Service? service;
  final Address? address;

  Shipping({this.courierCode, this.courierName, this.service, this.address});

  Shipping copyWith({
    String? courierCode,
    String? courierName,
    Service? service,
    Address? address,
  }) => Shipping(
    courierCode: courierCode ?? this.courierCode,
    courierName: courierName ?? this.courierName,
    service: service ?? this.service,
    address: address ?? this.address,
  );

  factory Shipping.fromRawJson(String str) =>
      Shipping.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
    courierCode: json["courier_code"],
    courierName: json["courier_name"],
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "courier_code": courierCode,
    "courier_name": courierName,
    "service": service?.toJson(),
    "address": address?.toJson(),
  };
}

class Address {
  final String? receiverName;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;

  Address({
    this.receiverName,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
  });

  Address copyWith({
    String? receiverName,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
  }) => Address(
    receiverName: receiverName ?? this.receiverName,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    receiverName: json["receiver_name"],
    phone: json["phone"],
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "receiver_name": receiverName,
    "phone": phone,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Service {
  final String? serviceCode;
  final String? serviceName;
  final String? estimation;
  final bool? isInsurance;
  final bool? isCod;

  Service({
    this.isInsurance,
    this.isCod,
    this.serviceCode,
    this.serviceName,
    this.estimation,
  });

  Service copyWith({
    String? serviceCode,
    String? serviceName,
    String? estimation,
    bool? isInsurance,
    bool? isCod,
  }) => Service(
    serviceCode: serviceCode ?? this.serviceCode,
    serviceName: serviceName ?? this.serviceName,
    estimation: estimation ?? this.estimation,
    isInsurance: isInsurance ?? this.isInsurance,
    isCod: isCod ?? this.isCod,
  );

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceCode: json["service_code"],
    serviceName: json["service_name"],
    estimation: json["estimation"],
    isInsurance: json["is_insurance"],
    isCod: json["is_cod"],
  );

  Map<String, dynamic> toJson() => {
    "service_code": serviceCode,
    "service_name": serviceName,
    "estimation": estimation,
    "is_insurance": isInsurance,
    "is_cod": isCod,
  };
}

extension CheckoutPayloadUpdater on CheckoutPayload {
  CheckoutPayload update({
    int? userId,
    int? pickupPointId,
    int? destinationId,
    int? originId,
    List<int>? cartIds,
    Shipping? shipping,

    String? courierCode,
    String? courierName,
    Service? service,
    Address? address,
    bool? isInsurance,
    bool? isCod,
  }) {
    // menjaga shipping lama agar tidak hilang
    final newShipping =
        (shipping ?? this.shipping)?.copyWith(
          courierCode: courierCode,
          courierName: courierName,
          service:
              service ??
              (this.shipping?.service?.copyWith(
                isInsurance: isInsurance ?? this.shipping?.service?.isInsurance,
                isCod: isCod ?? this.shipping?.service?.isCod,
              )),
          address: address ?? this.shipping?.address,
        ) ??
        shipping ??
        this.shipping;

    return copyWith(
      userId: userId,
      pickupPointId: pickupPointId,
      destinationId: destinationId,
      originId: originId,
      cartIds: cartIds,
      shipping: newShipping,
    );
  }
}
