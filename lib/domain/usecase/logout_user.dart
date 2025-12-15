import 'package:dartz/dartz.dart';

import '../repositories/repositories_domain.dart';

class LogoutUser {
  final RepositoriesDomain repositoriesDomain;

  LogoutUser(this.repositoriesDomain);

  Future<Either<String, String>> execute() async {
    return await repositoriesDomain.logoutUser();
  }
}
