import 'package:kas_autocare_user/domain/entities/sub_merchant_entity.dart';

class PaymentData {
  final int id;
  final String type;
  final int subMerchant;

  PaymentData({
    required this.subMerchant,
    required this.id,
    required this.type,
  });
}
