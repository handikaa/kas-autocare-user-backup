import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/domain/entities/banner_carousel_entity/banner_carousel_entity.dart';
import 'package:kas_autocare_user/domain/usecase/banner_carousel/get_list_banner_carousel_usecase.dart';

part 'get_list_banner_state.dart';

class GetListBannerCubit extends Cubit<GetListBannerState> {
  final GetListBannerCarouselUsecase usecase;

  GetListBannerCubit(this.usecase) : super(GetListBannerInitial());

  Future<void> execute() async {
    emit(GetListBannerLoading());

    final result = await usecase.execute();

    result.fold(
      (l) => emit(GetListBannerError(l)),
      (r) => emit(GetListBannerSuccess(r)),
    );
  }
}
