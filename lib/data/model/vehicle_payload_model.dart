import 'dart:convert';

class VehiclePayloadModel {
  final String plateNumber;
  final String type;
  final String brand;
  final String model;
  final String color;

  VehiclePayloadModel({
    required this.plateNumber,
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
  });

  factory VehiclePayloadModel.fromRawJson(String str) =>
      VehiclePayloadModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehiclePayloadModel.fromJson(Map<String, dynamic> json) =>
      VehiclePayloadModel(
        plateNumber: json["plate_number"],
        type: json["type"],
        brand: json["brand"],
        model: json["model"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
    "plate_number": plateNumber,
    "type": type,
    "brand": brand,
    "model": model,
    "color": color,
  };
}
