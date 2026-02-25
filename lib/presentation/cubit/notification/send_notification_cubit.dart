import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/notification/send_notification_usecase.dart';

part 'send_notification_state.dart';

class SendNotificationCubit extends Cubit<SendNotificationState> {
  final SendNotificationUsecase usecase;

  SendNotificationCubit(this.usecase) : super(SendNotificationInitial());

  Future<void> sendNotification({
    required String title,
    required String body,
    required String message,
    required int userId,
  }) async {
    emit(SendNotificationLoading());

    final result = await usecase.execute(
      body: body,
      title: title,
      message: message,
      userId: userId,
    );

    result.fold(
      (l) => emit(SendNotificationError(l)),
      (r) => emit(SendNotificationSuccess(r)),
    );
  }
}
