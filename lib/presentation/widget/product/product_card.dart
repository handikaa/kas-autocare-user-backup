import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/presentation/widget/layout/size.dart';
import 'package:kas_autocare_user/presentation/widget/layout/spacing.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';
import 'package:kas_autocare_user/presentation/widget/text/text_formater.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final double rating;
  final int price;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 110.0.rheight,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: AppPadding.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  align: TextAlign.left,
                  title,
                  variant: TextVariant.body2,
                  weight: TextWeight.bold,
                  maxLines: 2,
                ),
                AppGap.height(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: AppText(
                        align: TextAlign.left,
                        location,
                        variant: TextVariant.body3,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),

                AppGap.height(8),
                AppText(
                  TextFormatter.formatRupiah(price),
                  variant: TextVariant.body3,
                  weight: TextWeight.bold,
                ),
                AppGap.height(6),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    AppGap.width(4),
                    AppText(
                      rating.toString(),
                      variant: TextVariant.body3,
                      weight: TextWeight.medium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
