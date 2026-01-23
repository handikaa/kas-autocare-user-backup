import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:kas_autocare_user/domain/entities/banner_carousel_entity/banner_carousel_entity.dart';

class BannerCarouselModel extends Equatable {
  final int? id;
  final String? image;
  final String? link;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BannerCarouselModel({
    this.id,
    this.image,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerCarouselModel.fromRawJson(String str) =>
      BannerCarouselModel.fromJson(json.decode(str));

  factory BannerCarouselModel.fromJson(Map<String, dynamic> json) =>
      BannerCarouselModel(
        id: json["id"],
        image: json["image"],
        link: json["link"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  BannerCarouselEntity toEntity() =>
      BannerCarouselEntity(id: id ?? 0, image: image ?? '', link: link ?? '');

  @override
  List<Object?> get props => [id, image, link, createdAt, updatedAt];
}
