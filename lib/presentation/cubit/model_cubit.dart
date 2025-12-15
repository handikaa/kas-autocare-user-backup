import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/mvehicle_entity.dart';
import 'package:kas_autocare_user/domain/usecase/fetch_list_vmodel.dart';

part 'model_state.dart';

class ModelCubit extends Cubit<ModelState> {
  final FetchListVmodel fetchListModel;

  ModelCubit(this.fetchListModel) : super(ModelInitial());

  Future<void> getListModel({
    required String vType,
    required String brand,
  }) async {
    emit(ModelLoading());
    final result = await fetchListModel.execute(brand: brand, vType: vType);

    result.fold((l) => emit(ModelError(l)), (r) => emit(ModelLoaded(r)));
  }
}
