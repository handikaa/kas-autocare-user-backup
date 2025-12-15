import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/district_entity.dart';
import 'package:kas_autocare_user/domain/usecase/get_list_district.dart';

part 'list_district_state.dart';

class ListDistrictCubit extends Cubit<ListDistrictState> {
  final GetListDistrict getListDistrict;

  ListDistrictCubit(this.getListDistrict) : super(ListDistrictInitial());

  Future<void> fetchListDistrict(String? search) async {
    emit(ListDistrictLoading());
    final result = await getListDistrict.execute(search);

    result.fold(
      (l) => emit(ListDistrictError(l)),
      (r) => emit(ListDistrictLoaded(r)),
    );
  }
}
