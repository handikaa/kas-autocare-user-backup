import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/presentation/widget/layout/size.dart';

class AppOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? height;
  final double? borderRadius;

  final Color? buttonColor;

  const AppOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.borderRadius,

    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (height ?? 45.0).rheight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: buttonColor ?? AppColors.light.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          ),
          foregroundColor: buttonColor ?? AppColors.light.primary,
          textStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: buttonColor ?? AppColors.light.primary,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
