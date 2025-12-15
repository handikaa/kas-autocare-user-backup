import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/data/params/payload_address_input.dart';

import '../repositories/repositories_domain.dart';

class UpdateAddress {
  final RepositoriesDomain repositoriesDomain;

  UpdateAddress(this.repositoriesDomain);

  Future<Either<String, String>> execute({
    required PayloadAddressInput payload,
    required int id,
  }) async {
    return await repositoriesDomain.updateAddress(payload: payload, id: id);
  }
}
