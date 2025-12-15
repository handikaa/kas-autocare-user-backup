// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/presentation/widget/layout/spacing.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';

class MerchantCard extends StatelessWidget {
  final String? text;
  final int? type;
  final String img;
  final double? rating;
  final bool isSelected;
  final bool isOpen;
  final String? closeMessage;

  const MerchantCard({
    super.key,
    this.text,
    this.type,
    this.rating,
    this.isSelected = false,
    required this.img,
    required this.isOpen,
    this.closeMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.light.primary : Colors.transparent,
          width: isSelected ? 2.5 : 1,
        ),
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
              color: Colors.amber.shade400,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
            ),
          ),
          AppGap.width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text ?? "-",
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                AppGap.height(4),
                AppText(
                  type == 0 ? "Populer" : "Pelayanan Terbaik",
                  variant: TextVariant.body3,
                  weight: TextWeight.bold,
                ),
                AppGap.height(4),
                AppText(
                  "⭐ ${rating?.toStringAsFixed(1) ?? '0.0'}",
                  variant: TextVariant.body2,
                  weight: TextWeight.medium,
                  color: AppColors.common.grey500,
                ),
                AppGap.height(8),
                // if (!isOpen)
                //   AppText(
                //     "Tutup",
                //     variant: TextVariant.body3,
                //     weight: TextWeight.bold,
                //     color: AppColors.light.error,
                //   ),
                if (!isOpen)
                  AppText(
                    closeMessage ?? '',
                    variant: TextVariant.body3,
                    weight: TextWeight.bold,
                    color: AppColors.light.error,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
