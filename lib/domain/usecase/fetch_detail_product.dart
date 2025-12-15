import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/product_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchDetailProduct {
  final RepositoriesDomain repositoriesDomain;

  FetchDetailProduct(this.repositoriesDomain);

  Future<Either<String, ProductEntity>> execute(int id) async {
    return await repositoriesDomain.getDetailProduct(id);
  }
}
