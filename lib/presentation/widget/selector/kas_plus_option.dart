import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

class KasPlusOption extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  const KasPlusOption({super.key, required this.isSelected, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!isSelected);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.common.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      align: TextAlign.left,
                      'Kas Plus+ Waktu Anda Lebih Berharga',
                      variant: TextVariant.body2,
                      weight: TextWeight.semiBold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onChanged?.call(!isSelected);
                    },
                    child: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected ? Colors.blue : Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2C97A6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: AppText(
                align: TextAlign.left,
                maxLines: 3,
                'Lewati antrean dan tetap dilayani meski datang terlambat. Cukup tambah Rp10.000, nikmati layanan prioritas tanpa ribet',
                variant: TextVariant.body3,
                weight: TextWeight.medium,
                color: AppColors.common.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
