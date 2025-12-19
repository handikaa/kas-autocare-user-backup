import 'dart:convert';

class WinpayResponse {
  final String responseCode;
  final String responseMessage;
  final String partnerReferenceNo;
  final String? qrContent;
  final String? qrUrl;
  final String terminalId;
  final WinpayAdditionalInfo? additionalInfo;

  WinpayResponse({
    required this.responseCode,
    required this.responseMessage,
    required this.partnerReferenceNo,
    this.qrContent,
    this.qrUrl,
    required this.terminalId,
    this.additionalInfo,
  });

  /// Decode langsung dari string mentah
  factory WinpayResponse.fromRawJson(String raw) {
    final decodedOuter = json.decode(raw); // decode string → Map
    return WinpayResponse.fromJson(decodedOuter);
  }

  factory WinpayResponse.fromJson(Map<String, dynamic> json) {
    return WinpayResponse(
      responseCode: json["responseCode"] ?? "",
      responseMessage: json["responseMessage"] ?? "",
      partnerReferenceNo: json["partnerReferenceNo"] ?? "",
      qrContent: json["qrContent"],
      qrUrl: json["qrUrl"],
      terminalId: json["terminalId"] ?? "",
      additionalInfo: json["additionalInfo"] == null
          ? null
          : WinpayAdditionalInfo.fromJson(json["additionalInfo"]),
    );
  }
}

class WinpayAdditionalInfo {
  final String contractId;
  final DateTime expiredAt;
  final bool isStatic;

  WinpayAdditionalInfo({
    required this.contractId,
    required this.expiredAt,
    required this.isStatic,
  });

  factory WinpayAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return WinpayAdditionalInfo(
      contractId: json["contractId"] ?? "",
      expiredAt: json["expiredAt"] != null
          ? DateTime.parse(json["expiredAt"])
          : DateTime.now(),
      isStatic: json["isStatic"] ?? false,
    );
  }
}

class WinpayResponseProduct {
  final String? responseCode;
  final String? responseMessage;
  final String partnerReferenceNo;
  final QrData qrData;
  final AdditionalInfo additionalInfo;

  WinpayResponseProduct({
    required this.responseCode,
    required this.responseMessage,
    required this.partnerReferenceNo,
    required this.qrData,
    required this.additionalInfo,
  });

  factory WinpayResponseProduct.fromRawJson(String raw) {
    final decoded = json.decode(raw);
    return WinpayResponseProduct.fromJson(decoded);
  }

  factory WinpayResponseProduct.fromJson(Map<String, dynamic> json) {
    return WinpayResponseProduct(
      responseCode: json["responseCode"],
      responseMessage: json["responseMessage"],
      partnerReferenceNo: json["partnerReferenceNo"] ?? "",
      qrData: QrData.fromJson(json),
      additionalInfo: AdditionalInfo.fromJson(json["additionalInfo"] ?? {}),
    );
  }
}

class QrData {
  final String? qrContent;
  final String? qrUrl;

  QrData({this.qrContent, this.qrUrl});

  factory QrData.fromJson(Map<String, dynamic> json) =>
      QrData(qrContent: json["qrContent"], qrUrl: json["qrUrl"]);
}

class AdditionalInfo {
  final String? contractId;
  final String? expiredAt;
  final bool? isStatic;

  AdditionalInfo({this.contractId, this.expiredAt, this.isStatic});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    contractId: json["contractId"],
    expiredAt: json["expiredAt"],
    isStatic: json["isStatic"],
  );
}

class WinpayInfo {
  final String trxId;
  final String partnerReferenceNo;
  final String channel;

  WinpayInfo({
    required this.trxId,
    required this.partnerReferenceNo,
    required this.channel,
  });

  factory WinpayInfo.fromJson(Map<String, dynamic> json) => WinpayInfo(
    trxId: json["trxId"] ?? "",
    partnerReferenceNo: json["partnerReferenceNo"] ?? "",
    channel: json["channel"] ?? "",
  );
}
