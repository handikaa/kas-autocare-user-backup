// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

class AppBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final double? borderRadius;
  final bool useBorder;

  const AppBox({
    super.key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.borderRadius,
    this.useBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: useBorder
            ? Border.all(color: AppColors.common.black, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      width: width?.w,
      height: height?.h,
      child: child,
    );
  }
}

class AppGap extends StatelessWidget {
  final double? width;
  final double? height;

  const AppGap.width(double this.width, {super.key}) : height = null;

  const AppGap.height(double this.height, {super.key}) : width = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width?.w ?? 0, height: height?.h ?? 0);
  }
}

class AppPadding {
  static EdgeInsets all(double value) => EdgeInsets.all(value.w);
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value.w);
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value.h);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: left.w,
    top: top.h,
    right: right.w,
    bottom: bottom.h,
  );
}
