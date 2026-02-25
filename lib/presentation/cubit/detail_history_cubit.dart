import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/history/history_entity.dart';
import '../../domain/entities/history/history_transaction_entity.dart';
import '../../domain/usecase/fetch_detail_history.dart';

part 'detail_history_state.dart';

class DetailHistoryCubit extends Cubit<DetailHistoryState> {
  final FetchDetailHistory fetchDetailHistory;

  DetailHistoryCubit(this.fetchDetailHistory) : super(DetailHistoryInitial());

  Future<void> getDetailHistory(int id) async {
    emit(DetailHistoryLoading());

    final result = await fetchDetailHistory.execute(id);

    result.fold(
      (l) => emit(DetailHistoryError(l)),
      (r) => emit(DetailHistoryLoaded(r)),
    );
  }
}
