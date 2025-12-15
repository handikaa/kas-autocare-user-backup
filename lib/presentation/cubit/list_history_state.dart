part of 'list_history_cubit.dart';

abstract class ListHistoryState extends Equatable {
  const ListHistoryState();

  @override
  List<Object?> get props => [];
}

class ListHistoryInitial extends ListHistoryState {}

class ListHistoryLoading extends ListHistoryState {}

class ListHistoryLoadingFilter extends ListHistoryState {}

class ListHistoryLoaded extends ListHistoryState {
  final List<HistoryTransactionEntity> data;

  const ListHistoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ListHistoryError extends ListHistoryState {
  final String message;

  const ListHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
