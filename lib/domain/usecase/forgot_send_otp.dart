import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/repositories/repositories_domain.dart';

class ForgotSendOtp {
  final RepositoriesDomain repositoriesDomain;

  ForgotSendOtp(this.repositoriesDomain);

  Future<Either<String, String>> execute({required String email}) async {
    return await repositoriesDomain.forgotSendOtp(email: email);
  }
}
