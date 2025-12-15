import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/city_entity.dart';
import '../../domain/usecase/fetch_list_city.dart';

part 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  final FetchListCity fetchListCity;

  CityCubit(this.fetchListCity) : super(CityInitial());

  Future<void> getListCity() async {
    emit(CityLoading());
    final result = await fetchListCity.fetchListCityt();

    result.fold(
      (failure) => emit(CityError(failure)),
      (cities) => emit(CityLoaded(cities)),
    );
  }
}
