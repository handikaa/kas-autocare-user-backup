import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/repositories/repositories_domain.dart';

class ReadListNotificationUsecase {
  final RepositoriesDomain usecase;

  ReadListNotificationUsecase(this.usecase);

  Future<Either<String, String>> execute(List<int> notifId) async {
    return await usecase.readListNotif(notifId);
  }
}
