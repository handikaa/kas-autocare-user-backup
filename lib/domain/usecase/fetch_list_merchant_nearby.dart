import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/data/model/params_location.dart';
import 'package:kas_autocare_user/domain/entities/merchant_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchListMerchantNearby {
  final RepositoriesDomain repositoriesDomain;

  FetchListMerchantNearby(this.repositoriesDomain);

  Future<Either<String, List<MerchantEntity>>> execute(
    ParamsLocation params,
  ) async {
    return await repositoriesDomain.getListMerchantnearby(params);
  }
}
