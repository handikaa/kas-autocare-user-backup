import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/data/params/register_payload.dart';

import '../repositories/repositories_domain.dart';

class RegisterUser {
  final RepositoriesDomain repositoriesDomain;

  RegisterUser(this.repositoriesDomain);

  Future<Either<String, String>> execute(RegisterPayload payload) async {
    return await repositoriesDomain.registerUser(payload);
  }
}
