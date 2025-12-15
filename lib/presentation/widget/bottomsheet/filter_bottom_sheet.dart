import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../data/model/params_location.dart';
import '../widget.dart';

class FilterProductBottomSheet extends StatefulWidget {
  final String? initialCity;
  final String? initialSaleType;
  final String? initialPaymentMethod;

  const FilterProductBottomSheet({
    super.key,
    this.initialCity,
    this.initialSaleType,
    this.initialPaymentMethod,
  });

  @override
  State<FilterProductBottomSheet> createState() =>
      _FilterProductBottomSheetState();
}

class _FilterProductBottomSheetState extends State<FilterProductBottomSheet> {
  String? selectedCity;
  String? selectedSaleType;
  String? selectedPaymentMethod;

  final List<String> locationOptions = [
    "Jabodetabek",
    "Dki Jakarta",
    "Banten",
    "Bekasi",
    "Jakarta Pusat",
  ];

  final List<String> saleTypeOptions = ["Terbaru", "Terlaris"];
  final List<String> paymentOptions = ["COD", "QRIS"];

  @override
  void initState() {
    super.initState();
    selectedCity = widget.initialCity;
    selectedSaleType = widget.initialSaleType;
    selectedPaymentMethod = widget.initialPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const AppText(
              'Filter',
              variant: TextVariant.body2,
              weight: TextWeight.bold,
            ),
            AppGap.height(16),

            // Lokasi
            _buildSectionHeader(
              title: "Lokasi",
              actionText: "Lihat Semua",
              onTapAction: () async {
                final result = await context.push<ParamsLocation>(
                  '/find-location',
                  extra: 'city',
                );

                if (result != null && mounted) {
                  final cityName = result.city;

                  setState(() {
                    // ✅ Tambahkan city baru jika belum ada
                    if (!locationOptions.contains(cityName)) {
                      locationOptions.insert(0, cityName!);
                    }

                    // ✅ Pilih city yang baru dipilih
                    selectedCity = cityName;
                  });
                }
              },
            ),
            AppGap.height(8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: locationOptions.map((city) {
                final isSelected = selectedCity == city;
                return _buildChip(
                  label: city,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedCity = isSelected ? null : city;
                    });
                  },
                );
              }).toList(),
            ),

            AppGap.height(16),

            // Tipe Penjualan
            _buildSectionHeader(title: "Tipe Penjualan"),
            AppGap.height(8),
            Wrap(
              spacing: 8,
              children: saleTypeOptions.map((type) {
                final isSelected = selectedSaleType == type;
                return _buildChip(
                  label: type,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedSaleType = isSelected ? null : type;
                    });
                  },
                );
              }).toList(),
            ),

            AppGap.height(16),

            // Metode Pembayaran
            _buildSectionHeader(title: "Tipe Pembayaran"),
            AppGap.height(8),
            Wrap(
              spacing: 8,
              children: paymentOptions.map((method) {
                final isSelected = selectedPaymentMethod == method;
                return _buildChip(
                  label: method,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = isSelected ? null : method;
                    });
                  },
                );
              }).toList(),
            ),

            AppGap.height(24),

            // Tombol aksi
            SafeArea(
              child: Column(
                children: [
                  AppElevatedButton(
                    text: "Terapkan",
                    onPressed: () {
                      Navigator.pop(context, {
                        'city': selectedCity,
                        'saleType': selectedSaleType,
                        'paymentMethod': selectedPaymentMethod,
                      });
                    },
                  ),
                  AppGap.height(8),
                  AppOutlineButton(
                    text: "Reset",
                    onPressed: () {
                      setState(() {
                        selectedCity = null;
                        selectedSaleType = null;
                        selectedPaymentMethod = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            AppGap.height(8),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? actionText,
    VoidCallback? onTapAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(title, variant: TextVariant.body2, weight: TextWeight.bold),
        if (actionText != null)
          GestureDetector(
            onTap: onTapAction,
            child: AppText(
              actionText,
              color: AppColors.light.primary,
              variant: TextVariant.body3,
              weight: TextWeight.medium,
            ),
          ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.light.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.light.primary : Colors.grey.shade400,
          ),
        ),
        child: AppText(
          label,
          variant: TextVariant.body3,
          weight: TextWeight.medium,
          color: selected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
