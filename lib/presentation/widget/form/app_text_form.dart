import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../widget.dart';

class AppTextFormField extends StatelessWidget {
  final String? label;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool? isObsecure;
  final VoidCallback? onToggleObsecure;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool isRequired;
  final int? maxLines;
  final double? maxHeight;
  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;

  const AppTextFormField({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isObsecure,
    this.onToggleObsecure,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.maxLines,
    this.maxHeight,
    this.validator,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final obscure = isPassword ? (isObsecure ?? true) : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            children: [
              AppText(
                label!,
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),
              if (isRequired)
                AppText(
                  "*",
                  variant: TextVariant.body2,
                  weight: TextWeight.medium,
                  color: AppColors.light.error,
                ),
            ],
          ),
        const SizedBox(height: 8),
        Container(
          constraints: BoxConstraints(maxHeight: maxHeight ?? 150),

          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            keyboardType: keyboardType,
            onChanged: onChanged,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            minLines: 1,
            inputFormatters: inputFormatters,
            cursorColor: AppColors.light.primary,

            style: TextStyle(color: AppColors.common.black, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.common.grey400,
                fontSize: 14.0.rsp,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.common.black, width: 1),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.common.black, width: 1),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.light.primary,
                  width: 1,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.light.error, width: 1),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.light.error, width: 1),
              ),

              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: onToggleObsecure,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
