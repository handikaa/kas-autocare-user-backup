import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/history/history_transaction_entity.dart';

import '../../data/params/history_params.dart';
import '../../domain/usecase/fetch_list_history.dart';

part 'list_history_state.dart';

class ListHistoryCubit extends Cubit<ListHistoryState> {
  final FetchListHistory fetchListHistory;

  ListHistoryCubit(this.fetchListHistory) : super(ListHistoryInitial());

  Future<void> getListHistory(
    HistoryParams? params, {
    required int page,
  }) async {
    emit(ListHistoryLoading());
    final result = await fetchListHistory.execute(params, page: page);

    result.fold(
      (l) => emit(ListHistoryError(l)),
      (r) => emit(ListHistoryLoaded(r)),
    );
  }

  Future<void> getListHistoryFilter(
    HistoryParams? params, {
    required int page,
  }) async {
    emit(ListHistoryLoadingFilter());
    final result = await fetchListHistory.execute(params, page: page);

    result.fold(
      (l) => emit(ListHistoryError(l)),
      (r) => emit(ListHistoryLoaded(r)),
    );
  }
}
