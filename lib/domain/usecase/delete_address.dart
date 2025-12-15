import 'package:dartz/dartz.dart';

import '../repositories/repositories_domain.dart';

class DeleteAddress {
  final RepositoriesDomain repositoriesDomain;

  DeleteAddress(this.repositoriesDomain);

  Future<Either<String, String>> execute(int id) async {
    return await repositoriesDomain.deleteAddress(id);
  }
}
