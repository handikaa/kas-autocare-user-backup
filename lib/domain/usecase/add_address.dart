import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/data/params/payload_address_input.dart';

import '../repositories/repositories_domain.dart';

class AddAddress {
  final RepositoriesDomain repositoriesDomain;

  AddAddress(this.repositoriesDomain);

  Future<Either<String, String>> execute(PayloadAddressInput payload) async {
    return await repositoriesDomain.addAddress(payload);
  }
}
