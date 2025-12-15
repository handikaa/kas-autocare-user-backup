import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/address_entity.dart';

import '../repositories/repositories_domain.dart';

class FetchDetailAddress {
  final RepositoriesDomain repositoriesDomain;

  FetchDetailAddress(this.repositoriesDomain);

  Future<Either<String, AddressEntity>> execute(int id) async {
    return await repositoriesDomain.detailAddress(id);
  }
}
