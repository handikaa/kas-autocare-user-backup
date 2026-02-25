import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/usecase/notification/read_list_notification_usecase.dart';

part 'read_list_notification_state.dart';

class ReadListNotificationCubit extends Cubit<ReadListNotificationState> {
  final ReadListNotificationUsecase usecase;

  ReadListNotificationCubit(this.usecase) : super(ReadListNotifInitial());

  Future<void> readListNotif(List<int> notifId) async {
    emit(ReadListNotifLoading());

    final result = await usecase.execute(notifId);

    result.fold(
      (l) => emit(ReadListNotifError(l)),
      (r) => emit(ReadListNotifSuccess(r)),
    );
  }
}
