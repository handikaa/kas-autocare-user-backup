part of 'get_list_notification_cubit.dart';

abstract class GetListNotificationState extends Equatable {
  const GetListNotificationState();

  @override
  List<Object?> get props => [];
}

class GetListNotifInitial extends GetListNotificationState {}

class GetListNotifLoading extends GetListNotificationState {}

class GetListNotifSuccess extends GetListNotificationState {
  final List<NotificationEntity> data;
  const GetListNotifSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class GetListNotifError extends GetListNotificationState {
  final String message;
  const GetListNotifError(this.message);

  @override
  List<Object?> get props => [message];
}
