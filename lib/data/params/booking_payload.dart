import 'dart:convert';

class BookingPayload {
  final int? userId;
  final int branchId;
  final int? customersId;
  final String licensePlate;
  final String vehicleType;
  final String brand;
  final String model;
  final String color;
  final int bussinesId;
  final int variantNewsId;

  final int bussinesUnitId;
  final int packageNewsId;
  final List<int> serviceNewsId;
  final DateTime scheduleDate;
  final String scheduleTime;
  final bool isKasPlus;

  BookingPayload({
    required this.variantNewsId,
    this.userId,
    required this.branchId,
    this.customersId,
    required this.licensePlate,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.color,
    required this.bussinesId,

    required this.bussinesUnitId,
    required this.packageNewsId,
    required this.serviceNewsId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.isKasPlus,
  });

  BookingPayload copyWith({
    int? userId,
    int? branchId,
    int? customersId,
    String? licensePlate,
    String? vehicleType,
    String? brand,
    String? model,
    String? color,
    int? bussinesId,
    dynamic branchEmployeId,
    int? bussinesUnitId,
    int? packageNewsId,
    int? variantNewsId,
    List<int>? serviceNewsId,
    DateTime? scheduleDate,
    String? scheduleTime,
    bool? isKasPlus,
  }) => BookingPayload(
    userId: userId ?? this.userId,
    branchId: branchId ?? this.branchId,
    customersId: customersId ?? this.customersId,
    licensePlate: licensePlate ?? this.licensePlate,
    vehicleType: vehicleType ?? this.vehicleType,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    color: color ?? this.color,
    bussinesId: bussinesId ?? this.bussinesId,

    bussinesUnitId: bussinesUnitId ?? this.bussinesUnitId,
    packageNewsId: packageNewsId ?? this.packageNewsId,
    serviceNewsId: serviceNewsId ?? this.serviceNewsId,
    scheduleDate: scheduleDate ?? this.scheduleDate,
    scheduleTime: scheduleTime ?? this.scheduleTime,
    isKasPlus: isKasPlus ?? this.isKasPlus,
    variantNewsId: variantNewsId ?? this.variantNewsId,
  );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "branch_id": branchId,
    "customers_id": customersId,
    "license_plate": licensePlate,
    "vehicle_type": vehicleType,
    "brand": brand,
    "model": model,
    "color": color,
    "bussines_id": bussinesId,
    if (variantNewsId != 0) "variant_news_id": variantNewsId,
    "business_unit_id": bussinesUnitId,
    "package_news_id": packageNewsId,
    "service_news_id": List<dynamic>.from(serviceNewsId.map((x) => x)),
    "schedule_date":
        "${scheduleDate.year.toString().padLeft(4, '0')}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}",
    "schedule_time": scheduleTime,
    "is_kas_plus": isKasPlus,
  };
}
