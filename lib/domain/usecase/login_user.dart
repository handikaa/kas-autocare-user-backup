import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/authentification_entity.dart';

import '../../data/params/login_params.dart';
import '../repositories/repositories_domain.dart';

class LoginUser {
  final RepositoriesDomain repositoriesDomain;

  LoginUser(this.repositoriesDomain);

  Future<Either<String, AuthentificationEntity>> execute({
    required LoginParams payload,
  }) {
    return repositoriesDomain.loginUser(payload);
  }
}
