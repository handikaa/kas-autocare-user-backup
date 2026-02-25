import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/qr_product_entity.dart';
import '../../domain/usecase/generate_qr_product.dart';
import '../../domain/usecase/generate_qr_service.dart';

part 'generate_qr_state.dart';

class GenerateQrCubit extends Cubit<GenerateQrState> {
  final GenerateQrProduct generateQrProduct;
  final GenerateQrService generateQrService;

  GenerateQrCubit(this.generateQrProduct, this.generateQrService)
    : super(GenerateQrStateInitial());

  Future<void> getGenerateQrProductCubit({
    required int id,
    required int idMerchant,
  }) async {
    emit(GenerateQrStateLoading());

    final result = await generateQrProduct.execute(
      id: id,
      idMerchant: idMerchant,
    );

    result.fold(
      (l) => emit(GenerateQrStateError(l)),
      (r) => emit(GenerateQrStateSuccess(r)),
    );
  }

  Future<void> getGenerateQrServiceCubit({
    required int id,
    required int idMerchant,
  }) async {
    emit(GenerateQrStateLoading());

    final result = await generateQrService.execute(
      id: id,
      idMerchant: idMerchant,
    );

    result.fold(
      (l) => emit(GenerateQrStateError(l)),
      (r) => emit(GenerateQrStateSuccess(r)),
    );
  }
}
