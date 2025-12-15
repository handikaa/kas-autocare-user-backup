import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

import '../../../core/config/theme/app_text_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final TextWeight weight;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final double? minFontSize;
  final double? stepGranularity;

  const AppText(
    this.text, {
    super.key,
    required this.variant,
    this.weight = TextWeight.regular,
    this.color,
    this.align,
    this.maxLines,
    this.minFontSize,
    this.stepGranularity,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: align ?? TextAlign.center,
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 10,
      stepGranularity: stepGranularity ?? 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.style(
        variant: variant,
        weight: weight,
        color: color ?? AppColors.common.black,
      ),
    );
  }
}
