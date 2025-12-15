// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../layout/size.dart';
import '../widget.dart';

class VehicleTypeSelector extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const VehicleTypeSelector({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<VehicleTypeSelector> createState() => _VehicleTypeSelectorState();
}

class _VehicleTypeSelectorState extends State<VehicleTypeSelector> {
  String? selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialValue;
  }

  void _onSelect(String value) {
    setState(() => selectedType = value);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AppText(
              'Pilih Tipe Kendaraan',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _vehicleOption(
              label: "Mobil",
              value: "car",
              icon: Icons.directions_car_filled,
            ),
            _vehicleOption(
              label: "Motor",
              value: "motorcycle",
              icon: Icons.motorcycle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _vehicleOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final bool isSelected = selectedType == value;
    return GestureDetector(
      onTap: () => _onSelect(value),
      child: Container(
        width: 120.0.rwidth,
        height: 48.0.rheight,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.light.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.0.rwidth),
          border: Border.all(
            color: isSelected ? AppColors.light.primary : Colors.grey.shade300,
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.light.primary
                  : Colors.grey.shade600,
            ),
            SizedBox(width: 8.0.rwidth),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0.rsp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.light.primary
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
