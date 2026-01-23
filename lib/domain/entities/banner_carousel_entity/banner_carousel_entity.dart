import 'package:equatable/equatable.dart';

class BannerCarouselEntity extends Equatable {
  final int id;
  final String image;
  final String link;

  const BannerCarouselEntity({
    required this.id,
    required this.image,
    required this.link,
  });

  @override
  List<Object?> get props => [id, image, link];
}
