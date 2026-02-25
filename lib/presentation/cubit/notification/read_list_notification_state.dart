part of 'read_list_notification_cubit.dart';

abstract class ReadListNotificationState extends Equatable {
  const ReadListNotificationState();

  @override
  List<Object?> get props => [];
}

class ReadListNotifInitial extends ReadListNotificationState {}

class ReadListNotifLoading extends ReadListNotificationState {}

class ReadListNotifSuccess extends ReadListNotificationState {
  final String message;
  const ReadListNotifSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ReadListNotifError extends ReadListNotificationState {
  final String message;
  const ReadListNotifError(this.message);

  @override
  List<Object?> get props => [message];
}
