import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/qr_product_entity.dart';

class QrProductModel extends Equatable {
  final int? expiredInMinutes;
  final int? totalTransactionPrice;
  final String? qrUrl;
  final String? contractId;
  final QrModel? qrModel;
  const QrProductModel({
    this.qrModel,
    this.expiredInMinutes,
    this.totalTransactionPrice,
    this.qrUrl,
    this.contractId,
  });

  factory QrProductModel.fromRawJson(String str) =>
      QrProductModel.fromJson(json.decode(str));

  factory QrProductModel.fromJson(Map<String, dynamic> json) => QrProductModel(
    expiredInMinutes: json["expired_in_minutes"],
    totalTransactionPrice: json["total_transaction_price"],
    qrUrl: json["qr_url"] ?? json["url"],
    contractId: json["contract_id"],
    qrModel: json['qr'] == null ? null : QrModel.fromJson(json['qr']),
  );

  QrProductEntity toEntity() => QrProductEntity(
    expiredInMinutes: expiredInMinutes ?? 0,
    totalTransactionPrice: totalTransactionPrice ?? 0,
    qrUrl: qrUrl ?? '',
    contractId: contractId ?? '',
    qrEntity:
        qrModel?.toEntity() ?? QrEntity(content: '', url: '', contractId: ''),
  );

  @override
  List<Object?> get props => [
    expiredInMinutes,
    totalTransactionPrice,
    qrUrl,
    contractId,
  ];
}

class QrModel extends Equatable {
  final String? content;
  final String? url;
  final String? contractId;

  QrModel({this.content, this.url, this.contractId});

  factory QrModel.fromRawJson(String str) => QrModel.fromJson(json.decode(str));

  factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
    content: json["content"],
    url: json["url"],
    contractId: json["contract_id"],
  );

  QrEntity toEntity() => QrEntity(
    content: content ?? '',
    url: url ?? "",
    contractId: contractId ?? '',
  );

  @override
  List<Object?> get props => [content, url, contractId];
}
