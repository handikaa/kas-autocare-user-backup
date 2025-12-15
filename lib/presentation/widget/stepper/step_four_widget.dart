import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/config/theme/app_text_style.dart';
import '../../../domain/entities/merchant_entity.dart';
import '../../../domain/entities/package_entity.dart';
import '../../../domain/entities/service_entity.dart';
import '../widget.dart';

// ignore: must_be_immutable
class StepFourWidget extends StatefulWidget {
  final String? vehicleType;
  final String? brand;
  final String? model;

  final MerchantEntity? selectedMerchant;

  final PackageEntity? selectedPackage;
  final List<ServiceEntity>? selectedServices;
  final DateTime? selectedDate;
  final String? selectedHour;
  String? plateNumber;
  final ValueChanged<bool>? onKasPlusChanged;

  StepFourWidget({
    super.key,
    this.plateNumber,
    this.vehicleType,
    this.brand,
    this.model,
    this.selectedMerchant,
    this.selectedPackage,
    this.selectedServices,
    this.selectedDate,
    this.selectedHour,
    this.onKasPlusChanged,
  });

  @override
  State<StepFourWidget> createState() => _StepFourWidgetState();
}

class _StepFourWidgetState extends State<StepFourWidget> {
  bool isKasPlusSelected = false;

  PackageEntity? packageName;
  VariantTypeEntity? variantType;
  VariantEntity? variant;
  int hargaUtama = 0;

  @override
  void initState() {
    super.initState();

    if (widget.selectedPackage != null) {
      packageName = widget.selectedPackage;
      if (packageName!.variantTypes.isNotEmpty) {
        variantType = packageName!.variantTypes.first;
        variant = variantType!.variants.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = widget.selectedDate != null
        ? DateFormat("dd MMMM yyyy", "id_ID").format(widget.selectedDate!)
        : "-";

    final formattedHour = widget.selectedHour ?? "-";

    return StepBaseWidget(
      currentStep: 4,
      totalSteps: 4,
      children: [
        Row(
          children: [
            AppText(
              'Informasi Kendaraan',
              variant: TextVariant.body1,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        VehicleInfoTable(
          plateNumber: widget.plateNumber,
          brand: widget.brand ?? "-",
          model: widget.model ?? "-",
          time: formattedHour,
          date: formattedDate,
        ),
        AppGap.height(18),

        Row(
          children: [
            AppText(
              'Informasi Carwash',
              variant: TextVariant.body1,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        CarwashTabel(
          name: widget.selectedMerchant?.storeName ?? "-",
          location: widget.selectedMerchant?.address ?? "-",
          urlLocation: widget.selectedMerchant?.urlCallback ?? "",
        ),
        AppGap.height(18),

        KasPlusOption(
          isSelected: isKasPlusSelected,
          onChanged: (val) {
            setState(() {
              isKasPlusSelected = val;
            });
            widget.onKasPlusChanged?.call(val);
          },
        ),
        AppGap.height(18),

        Row(
          children: [
            AppText(
              'Rincian Pesanan',
              variant: TextVariant.body1,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        RincianPesananCard(
          paketUtama: packageName!,
          hargaUtama: variantType != null
              ? variant?.price ?? 0
              : packageName?.price ?? 0,
          layananTambahan: widget.selectedServices ?? [],
          totalPembayaran: _calculateTotal(
            variantType != null ? variant?.price ?? 0 : packageName?.price ?? 0,
          ),
          isKasPlusSelected: isKasPlusSelected,
        ),
      ],
    );
  }

  int _calculateTotal(int basePrice) {
    final additional =
        widget.selectedServices?.fold<int>(
          0,
          (sum, service) => sum + service.price,
        ) ??
        0;

    final kasPlusFee = isKasPlusSelected ? 10000 : 0;

    return basePrice + additional + kasPlusFee;
  }
}
