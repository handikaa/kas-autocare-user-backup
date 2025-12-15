import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/qr_product_entity.dart';
import 'package:kas_autocare_user/domain/usecase/generate_qr_service.dart';

import '../../domain/usecase/generate_qr_product.dart';

part 'generate_qr_state.dart';

class GenerateQrCubit extends Cubit<GenerateQrState> {
  final GenerateQrProduct generateQrProduct;
  final GenerateQrService generateQrService;

  GenerateQrCubit(this.generateQrProduct, this.generateQrService)
    : super(GenerateQrStateInitial());

  Future<void> getGenerateQrProductCubit(int id) async {
    emit(GenerateQrStateLoading());

    final result = await generateQrProduct.execute(id);

    result.fold(
      (l) => emit(GenerateQrStateError(l)),
      (r) => emit(GenerateQrStateSuccess(r)),
    );
  }

  Future<void> getGenerateQrServiceCubit(int id) async {
    emit(GenerateQrStateLoading());

    final result = await generateQrService.execute(id);

    result.fold(
      (l) => emit(GenerateQrStateError(l)),
      (r) => emit(GenerateQrStateSuccess(r)),
    );
  }
}
