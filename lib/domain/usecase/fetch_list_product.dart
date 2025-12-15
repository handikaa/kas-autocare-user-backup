import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/product_entity.dart';

import '../../data/params/product_query_params.dart';
import '../repositories/repositories_domain.dart';

class FetchListProduct {
  final RepositoriesDomain repositoriesDomain;

  FetchListProduct(this.repositoriesDomain);

  Future<Either<String, List<ProductEntity>>> execute(
    ProductQueryParams params,
  ) async {
    return await repositoriesDomain.getListProduct(params);
  }
}
