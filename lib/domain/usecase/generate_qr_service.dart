import 'package:dartz/dartz.dart';

import '../entities/qr_product_entity.dart';
import '../repositories/repositories_domain.dart';

class GenerateQrService {
  final RepositoriesDomain repositoriesDomain;

  GenerateQrService(this.repositoriesDomain);

  Future<Either<String, QrProductEntity>> execute({
    required int id,
    required int idMerchant,
  }) async {
    return await repositoriesDomain.generateQRService(
      id: id,
      idMerchant: idMerchant,
    );
  }
}
