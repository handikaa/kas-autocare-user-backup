import 'package:dartz/dartz.dart';
import '../../repositories/repositories_domain.dart';

class Savefcmusecase {
  final RepositoriesDomain usecase;

  Savefcmusecase(this.usecase);

  Future<Either<String, String>> execute() async {
    return await usecase.saveFcmToServer();
  }
}
