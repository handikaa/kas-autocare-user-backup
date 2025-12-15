import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/presentation/widget/button/app_elevated_button.dart';
import 'package:kas_autocare_user/presentation/widget/layout/spacing.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';

class AddressCard extends StatelessWidget {
  final String name;
  final int phone;
  final String address;
  final bool isPrimary;
  final bool showButton;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,

    required this.name,
    required this.phone,
    required this.address,
    this.isPrimary = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppText(
                  name,
                  variant: TextVariant.body3,
                  weight: TextWeight.bold,
                ),
                const SizedBox(width: 8),
                if (isPrimary)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppText(
                      "Utama",
                      variant: TextVariant.body3,
                      weight: TextWeight.bold,
                      color: AppColors.light.primary,
                    ),
                  ),
              ],
            ),

            AppText(
              "$phone",
              variant: TextVariant.body3,
              weight: TextWeight.regular,
            ),

            AppGap.height(4),
            AppText(
              align: TextAlign.left,
              address,
              variant: TextVariant.body3,
              weight: TextWeight.regular,
            ),
            if (showButton) ...[
              AppGap.height(10),
              Row(
                children: [
                  Expanded(
                    child: AppElevatedButton(
                      text: "Ubah Alamat",
                      onPressed: onEdit,
                    ),
                  ),
                  if (onDelete != null) ...[
                    AppGap.height(8),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete),
                      color: AppColors.light.error,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
