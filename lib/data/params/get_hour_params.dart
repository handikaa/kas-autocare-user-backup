import 'dart:convert';

class GetHourParams {
  final int bussinesId;
  final int branchId;
  final String date;

  GetHourParams({
    required this.bussinesId,
    required this.branchId,
    required this.date,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "bussines_id": bussinesId,
    "branch_id": branchId,
    "date": date,
  };
}
