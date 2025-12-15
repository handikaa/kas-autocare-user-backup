import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/presentation/widget/icon/app_icon.dart';

class AppSearchForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final void Function(String)? onChanged;

  const AppSearchForm({
    super.key,
    required this.hintText,
    required this.controller,
    this.onSearch,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        cursorColor: AppColors.light.primary,

        controller: controller,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.common.black,
          fontWeight: FontWeight.w400,
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (_) {
          if (onSearch != null) onSearch!();
        },

        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: AppColors.common.grey500,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 10,
          ),
          // suffixIcon: IconButton(
          //   icon: const Icon(Icons.search, color: Color(0xFF4A4A4A)),
          //   onPressed: onSearch,
          // ),
          suffixIcon: AppIcon(icon: Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
