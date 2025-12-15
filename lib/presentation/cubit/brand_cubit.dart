import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/brand_entity.dart';
import '../../domain/usecase/fetch_list_brand.dart';

part 'brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  final FetchListBrand fetchListBrand;

  BrandCubit(this.fetchListBrand) : super(BrandInitial());

  Future<void> getListBrand(String vType) async {
    emit(BrandLoading());
    final result = await fetchListBrand.execute(vType);

    result.fold((l) => emit(BrandError(l)), (r) => emit(BrandLoaded(r)));
  }
}
