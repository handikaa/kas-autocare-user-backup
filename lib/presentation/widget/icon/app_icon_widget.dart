import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIconImage extends StatelessWidget {
  final String iconName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const AppIconImage(
    this.iconName, {
    super.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconName,
      width: (width ?? 24).w,
      height: height?.h,
      color: color,
      fit: fit,
    );
  }
}
