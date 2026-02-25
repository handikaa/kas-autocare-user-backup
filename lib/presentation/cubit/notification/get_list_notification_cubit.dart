import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/usecase/notification/get_list_notification_usecase.dart';

part 'get_list_notification_state.dart';

class GetListNotificationCubit extends Cubit<GetListNotificationState> {
  final GetListNotificationUsecase usecase;

  GetListNotificationCubit(this.usecase) : super(GetListNotifInitial());

  Future<void> getListNotif() async {
    emit(GetListNotifLoading());

    final result = await usecase.execute();

    result.fold(
      (l) => emit(GetListNotifError(l)),
      (r) => emit(GetListNotifSuccess(r)),
    );
  }
}
