import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/presentation/widget/layout/spacing.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';

class ProductTransactionCard extends StatelessWidget {
  const ProductTransactionCard({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
  });

  final String img;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppGap.width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  variant: TextVariant.body2,
                  align: TextAlign.left,
                  maxLines: 5,
                  weight: TextWeight.semiBold,
                ),

                AppGap.height(4),
                AppText(
                  subtitle,
                  variant: TextVariant.body3,
                  weight: TextWeight.medium,
                ),

                AppGap.height(4),

                // if (!isOpen)
                //   AppText(
                //     "Tutup",
                //     variant: TextVariant.body3,
                //     weight: TextWeight.bold,
                //     color: AppColors.light.error,
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
