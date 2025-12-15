import 'package:dartz/dartz.dart';

import '../repositories/repositories_domain.dart';

class RegistCheckEmail {
  final RepositoriesDomain repositoriesDomain;

  RegistCheckEmail(this.repositoriesDomain);

  Future<Either<String, bool>> execute({required String email}) async {
    return await repositoriesDomain.registerCheckEmail(email: email);
  }
}
