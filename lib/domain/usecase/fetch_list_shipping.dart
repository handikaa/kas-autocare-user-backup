import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/data/params/shipping_params.dart';
import 'package:kas_autocare_user/domain/entities/shipping_entity.dart';
import 'package:kas_autocare_user/domain/repositories/repositories_domain.dart';

class FetchListShipping {
  final RepositoriesDomain repositoriesDomain;

  FetchListShipping(this.repositoriesDomain);

  Future<Either<String, CheckShippingEntity>> execute(
    ShippingParams params,
  ) async {
    return await repositoriesDomain.getListShipping(params);
  }
}
