part of 'get_list_banner_cubit.dart';

abstract class GetListBannerState extends Equatable {
  const GetListBannerState();

  @override
  List<Object?> get props => [];
}

class GetListBannerInitial extends GetListBannerState {}

class GetListBannerLoading extends GetListBannerState {}

class GetListBannerSuccess extends GetListBannerState {
  final List<BannerCarouselEntity> data;
  const GetListBannerSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class GetListBannerError extends GetListBannerState {
  final String message;
  const GetListBannerError(this.message);

  @override
  List<Object?> get props => [message];
}
