import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/repositories/repositories_domain.dart';

class VerifyOtp {
  final RepositoriesDomain usecase;

  VerifyOtp(this.usecase);

  Future<Either<String, String>> execute({
    required String email,
    required String code,
  }) async {
    return await usecase.registerVerifyOtp(email: email, code: code);
  }
}
