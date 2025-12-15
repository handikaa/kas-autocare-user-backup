import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/repositories/repositories_domain.dart';

class ForgotVerifyOtp {
  final RepositoriesDomain repositoriesDomain;

  ForgotVerifyOtp(this.repositoriesDomain);

  Future<Either<String, String>> execute({
    required String email,
    required String otp,
  }) async {
    return await repositoriesDomain.forgotVerifyOtp(email: email, otp: otp);
  }
}
