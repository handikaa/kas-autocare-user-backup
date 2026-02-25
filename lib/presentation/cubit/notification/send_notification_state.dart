part of 'send_notification_cubit.dart';

abstract class SendNotificationState extends Equatable {
  const SendNotificationState();

  @override
  List<Object?> get props => [];
}

class SendNotificationInitial extends SendNotificationState {}

class SendNotificationLoading extends SendNotificationState {}

class SendNotificationSuccess extends SendNotificationState {
  final String message;

  const SendNotificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SendNotificationError extends SendNotificationState {
  final String message;

  const SendNotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
