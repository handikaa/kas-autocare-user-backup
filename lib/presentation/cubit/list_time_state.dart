part of 'list_time_cubit.dart';

abstract class ListTimeState extends Equatable {
  const ListTimeState();

  @override
  List<Object?> get props => [];
}

class ListTimeInitial extends ListTimeState {}

class ListTimeLoading extends ListTimeState {}

class ListTimeLoaded extends ListTimeState {
  final List<TimeEntity> data;

  const ListTimeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ListTimeError extends ListTimeState {
  final String message;

  const ListTimeError(this.message);

  @override
  List<Object?> get props => [message];
}
