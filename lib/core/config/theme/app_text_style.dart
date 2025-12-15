import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum TextVariant {
  display1,
  display2,
  heading1,
  heading2,
  heading3,
  heading4,
  heading5,
  heading6,
  heading7,
  heading8,
  body1,
  body2,
  body3,
}

enum TextWeight { light, regular, medium, semiBold, bold }

extension TextWeightExt on TextWeight {
  FontWeight get value {
    switch (this) {
      case TextWeight.light:
        return FontWeight.w300;
      case TextWeight.regular:
        return FontWeight.w400;
      case TextWeight.medium:
        return FontWeight.w500;
      case TextWeight.semiBold:
        return FontWeight.w600;
      case TextWeight.bold:
        return FontWeight.w700;
    }
  }
}

extension TextVariantExt on TextVariant {
  double get size {
    switch (this) {
      case TextVariant.display1:
        return 60.sp;
      case TextVariant.display2:
        return 54.sp;
      case TextVariant.heading1:
        return 48.sp;
      case TextVariant.heading2:
        return 42.sp;
      case TextVariant.heading3:
        return 38.sp;
      case TextVariant.heading4:
        return 32.sp;
      case TextVariant.heading5:
        return 28.sp;
      case TextVariant.heading6:
        return 24.sp;
      case TextVariant.heading7:
        return 20.sp;
      case TextVariant.heading8:
        return 16.sp;
      case TextVariant.body1:
        return 16.sp;
      case TextVariant.body2:
        return 14.sp;
      case TextVariant.body3:
        return 12.sp;
    }
  }
}

class AppTextStyles {
  static TextStyle style({
    required TextVariant variant,
    TextWeight weight = TextWeight.regular,
    Color color = Colors.black,
  }) {
    return GoogleFonts.inter(
      fontSize: variant.size,
      fontWeight: weight.value,
      color: color,
    );
  }
}
