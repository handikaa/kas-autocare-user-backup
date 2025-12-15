import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/address_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchListAddress {
  final RepositoriesDomain repositoriesDomain;

  FetchListAddress(this.repositoriesDomain);

  Future<Either<String, List<AddressEntity>>> execute() async {
    return await repositoriesDomain.getListAddress();
  }
}
