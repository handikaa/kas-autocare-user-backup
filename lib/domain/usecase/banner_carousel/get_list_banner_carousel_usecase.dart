import 'package:dartz/dartz.dart';
import 'package:kas_autocare_user/domain/entities/banner_carousel_entity/banner_carousel_entity.dart';

import '../../repositories/repositories_domain.dart';

class GetListBannerCarouselUsecase {
  final RepositoriesDomain usecase;

  GetListBannerCarouselUsecase(this.usecase);

  Future<Either<String, List<BannerCarouselEntity>>> execute() async {
    return await usecase.getListCarouselBanner();
  }
}
