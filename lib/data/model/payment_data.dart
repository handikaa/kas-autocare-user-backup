class PaymentData {
  final int id;
  final String type;
  final String? plate;
  final String? code;
  final int? userId;
  final int subMerchant;

  PaymentData({
    required this.subMerchant,
    required this.id,
    required this.type,
    this.plate,
    this.code,
    this.userId,
  });
}
