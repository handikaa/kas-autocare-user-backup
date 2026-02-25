part of 'detail_history_cubit.dart';

abstract class DetailHistoryState extends Equatable {
  const DetailHistoryState();

  @override
  List<Object?> get props => [];
}

class DetailHistoryInitial extends DetailHistoryState {}

class DetailHistoryLoading extends DetailHistoryState {}

class DetailHistoryLoaded extends DetailHistoryState {
  final HistoryEntity data;

  const DetailHistoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DetailHistoryError extends DetailHistoryState {
  final String message;

  const DetailHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
