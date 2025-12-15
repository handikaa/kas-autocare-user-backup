class HistoryParams {
  final String? convertstartDate;
  final String? selectedstartDate;
  final String? convertendDate;
  final String? selectedendDate;
  final String? status;
  final String? statusValue;

  HistoryParams({
    required this.convertstartDate,
    required this.selectedstartDate,
    required this.convertendDate,
    required this.selectedendDate,
    required this.status,
    required this.statusValue,
  });
}

extension HistoryParamsMapper on HistoryParams {
  Map<String, dynamic> toQuery() {
    final map = <String, dynamic>{};

    if (convertstartDate != null && convertstartDate!.isNotEmpty) {
      map["start_date"] = convertstartDate;
    }
    if (convertendDate != null && convertendDate!.isNotEmpty) {
      map["end_date"] = convertendDate;
    }
    if (statusValue != null && statusValue!.isNotEmpty) {
      map["status"] = statusValue;
    }

    return map;
  }
}
