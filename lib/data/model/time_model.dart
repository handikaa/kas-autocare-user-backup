import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/time_entity.dart';

class TimeModel extends Equatable {
  final String? time;
  final String? timeFormatted;
  final bool? available;
  final String? status;
  final String? colorCode;

  const TimeModel({
    this.time,
    this.timeFormatted,
    this.available,
    this.status,
    this.colorCode,
  });

  factory TimeModel.fromRawJson(String str) =>
      TimeModel.fromJson(json.decode(str));

  factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
    time: json["time"],
    timeFormatted: json["time_formatted"],
    available: json["available"],
    status: json["status"],
    colorCode: json["color_code"],
  );

  TimeEntity toEntity() => TimeEntity(
    time: time ?? "-",
    timeFormatted: timeFormatted ?? "-",
    available: available ?? false,
    status: status ?? "-",
    colorCode: colorCode ?? "#000000",
  );

  @override
  List<Object?> get props => [
    time,
    timeFormatted,
    available,
    status,
    colorCode,
  ];
}
