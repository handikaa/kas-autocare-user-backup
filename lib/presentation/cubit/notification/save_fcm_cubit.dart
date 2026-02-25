import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/usecase/authentification/save_fcm_usecase.dart';

part 'save_fcm_state.dart';

class SaveFcmCubit extends Cubit<SaveFcmState> {
  final Savefcmusecase usecase;

  SaveFcmCubit(this.usecase) : super(SaveFcmInitial());

  Future<void> saveFcm() async {
    emit(SaveFcmLoading());

    final result = await usecase.execute();

    result.fold((l) => emit(SaveFcmError(l)), (r) => emit(SaveFcmSuccess(r)));
  }
}
