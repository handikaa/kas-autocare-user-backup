import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

class AppCircularLoading extends StatelessWidget {
  const AppCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: AppColors.light.primary);
  }
}
