import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;

  final double size;

  final Color? color;

  final VoidCallback? onTap;

  const AppIcon({
    super.key,
    required this.icon,
    this.size = 16,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.common.white;

    final iconWidget = Icon(icon, size: size, color: effectiveColor);

    if (onTap == null) return iconWidget;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size),
      child: iconWidget,
    );
  }
}
