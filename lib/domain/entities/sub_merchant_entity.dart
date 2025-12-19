import 'package:equatable/equatable.dart';

class SubMerchantEntity extends Equatable {
  final int id;
  final int idMerchant;

  const SubMerchantEntity({required this.id, required this.idMerchant});

  @override
  List<Object?> get props => [id, idMerchant];
}
