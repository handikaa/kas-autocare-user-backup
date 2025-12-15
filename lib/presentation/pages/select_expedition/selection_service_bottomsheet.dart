import 'package:flutter/material.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../data/model/expedition_model.dart';
import '../../widget/widget.dart';

class ServiceSelectionSheet extends StatefulWidget {
  final List<ShippingService> services;
  final ShippingService? selected;

  const ServiceSelectionSheet({
    super.key,
    required this.services,
    this.selected,
  });

  @override
  State<ServiceSelectionSheet> createState() => ServiceSelectionSheetState();
}

class ServiceSelectionSheetState extends State<ServiceSelectionSheet> {
  ShippingService? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          color: Colors.white, // ✅ background putih
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ drag indicator
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
                'Pilih Jenis Pengiriman',
                variant: TextVariant.body2,
                weight: TextWeight.bold,
              ),
              const SizedBox(height: 12),

              // ✅ daftar pilihan service
              ...widget.services.map((s) {
                return RadioListTile<ShippingService>(
                  value: s,
                  groupValue: _selected,
                  onChanged: (val) => setState(() => _selected = val),
                  title: Text(s.name),
                  subtitle: Text("Rp${s.price}"),
                  activeColor: AppColors.light.primary,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),

              const SizedBox(height: 16),

              // ✅ tombol terapkan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.light.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Terapkan"),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
