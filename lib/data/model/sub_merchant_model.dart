import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/core/utils/share_method.dart';
import 'package:kas_autocare_user/domain/entities/sub_merchant_entity.dart';

class SubMerchantModel extends Equatable {
  final int? id;
  final int? idMerchant;

  SubMerchantModel({this.id, this.idMerchant});

  factory SubMerchantModel.fromRawJson(String str) =>
      SubMerchantModel.fromJson(json.decode(str));

  factory SubMerchantModel.fromJson(Map<String, dynamic> json) =>
      SubMerchantModel(
        id: json["id"],
        idMerchant: ShareMethod.parseToInt(json["id_merchant"]),
      );

  SubMerchantEntity toEntity() =>
      SubMerchantEntity(id: id ?? 0, idMerchant: idMerchant ?? 0);

  @override
  List<Object?> get props => [id, idMerchant];
}
