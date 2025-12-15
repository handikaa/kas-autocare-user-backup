import 'package:flutter/material.dart';
import 'package:kas_autocare_user/presentation/widget/button/app_elevated_button.dart';
import 'package:kas_autocare_user/presentation/widget/button/app_outline_button.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

import '../../../core/config/theme/app_colors.dart';

class ConfirmDeleteBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Wrap(
            spacing: 10,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: AppElevatedButton(
                  text: "Hapus Alamat",
                  backgroundColor: AppColors.light.error,
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                ),
              ),

              AppGap.height(12),

              SizedBox(
                width: double.infinity,
                child: AppOutlineButton(
                  text: "Batal",
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
