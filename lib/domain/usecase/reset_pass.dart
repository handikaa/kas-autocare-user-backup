import 'package:dartz/dartz.dart';

import '../repositories/repositories_domain.dart';

class ResetPass {
  final RepositoriesDomain repositoriesDomain;

  ResetPass(this.repositoriesDomain);

  Future<Either<String, String>> execute({
    required String email,
    required String pass,
    required String confirmPass,
  }) async {
    return await repositoriesDomain.resetPass(
      email: email,
      pass: pass,
      confirmPass: confirmPass,
    );
  }
}
