import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/params/get_hour_params.dart';
import '../../domain/entities/time_entity.dart';
import '../../domain/usecase/fetch_list_time.dart';

part 'list_time_state.dart';

class ListTimeCubit extends Cubit<ListTimeState> {
  final FetchListTime fetchListTime;

  ListTimeCubit(this.fetchListTime) : super(ListTimeInitial());

  Future<void> getListTIme({required GetHourParams params}) async {
    emit(ListTimeLoading());
    final result = await fetchListTime.execute(params: params);

    result.fold((l) => emit(ListTimeError(l)), (r) => emit(ListTimeLoaded(r)));
  }
}
