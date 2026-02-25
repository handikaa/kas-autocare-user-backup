import 'package:dartz/dartz.dart';

import '../../repositories/repositories_domain.dart';

class SendNotificationUsecase {
  final RepositoriesDomain usecase;

  SendNotificationUsecase(this.usecase);

  Future<Either<String, String>> execute({
    required String title,
    required String body,
    required String message,
    required int userId,
  }) async {
    return await usecase.sendNotif(
      body: body,
      title: title,
      message: message,
      userId: userId,
    );
  }
}
