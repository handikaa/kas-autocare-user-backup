import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/notification/notification_entity.dart';

import '../../repositories/repositories_domain.dart';

class GetListNotificationUsecase {
  final RepositoriesDomain usecase;

  GetListNotificationUsecase(this.usecase);

  Future<Either<String, List<NotificationEntity>>> execute() async {
    return await usecase.getListNotif();
  }
}
