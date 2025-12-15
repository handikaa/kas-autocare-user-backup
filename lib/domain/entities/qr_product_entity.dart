import 'package:equatable/equatable.dart';

class QrProductEntity extends Equatable {
  final int expiredInMinutes;
  final int totalTransactionPrice;
  final String qrUrl;
  final QrEntity qrEntity;
  final String contractId;

  const QrProductEntity({
    required this.qrEntity,
    required this.expiredInMinutes,
    required this.totalTransactionPrice,
    required this.qrUrl,
    required this.contractId,
  });

  @override
  List<Object?> get props => [
    expiredInMinutes,
    totalTransactionPrice,
    qrUrl,
    contractId,
    qrEntity,
  ];
}

class QrEntity extends Equatable {
  final String content;
  final String url;
  final String contractId;

  QrEntity({
    required this.content,
    required this.url,
    required this.contractId,
  });

  @override
  List<Object?> get props => [content, url, contractId];
}
