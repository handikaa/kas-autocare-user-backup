import 'package:flutter/material.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

import '../../../core/config/theme/app_colors.dart';

class SearchBorder extends StatelessWidget {
  const SearchBorder({
    super.key,
    required TextEditingController searchController,
    required this.searchHint,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: AppColors.common.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: AppColors.light.primary,
        decoration: InputDecoration(
          hintText: searchHint,

          hintStyle: TextStyle(
            color: AppColors.common.black,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.common.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.common.black, width: 1.4),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.light.primary, width: 1),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.light.error, width: 1),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.light.error, width: 1),
          ),

          border: OutlineInputBorder(
            borderSide: BorderSide(width: 10),
            borderRadius: BorderRadius.circular(12),
          ),
          isDense: true,
        ),
      ),
    );
  }
}
