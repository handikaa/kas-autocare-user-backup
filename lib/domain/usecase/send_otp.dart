import 'package:dartz/dartz.dart';

import '../repositories/repositories_domain.dart';

class SendOtp {
  final RepositoriesDomain repositoriesDomain;

  SendOtp(this.repositoriesDomain);

  Future<Either<String, String>> execute({required String email}) async {
    return await repositoriesDomain.registerSendOtp(email: email);
  }
}
