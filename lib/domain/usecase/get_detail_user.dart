import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/user_entity.dart';

import '../repositories/repositories_domain.dart';

class GetDetailUser {
  final RepositoriesDomain repositoriesDomain;

  GetDetailUser(this.repositoriesDomain);

  Future<Either<String, UserEntity>> execute() async {
    return await repositoriesDomain.getDetailUser();
  }
}
