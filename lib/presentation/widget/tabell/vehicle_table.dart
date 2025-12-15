import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/presentation/widget/text/app_text.dart';

class VehicleInfoTable extends StatelessWidget {
  final String? plateNumber;
  final String? brand;
  final String? model;
  final String? date;
  final String? time;

  const VehicleInfoTable({
    super.key,
    this.plateNumber,
    this.brand,
    this.model,
    this.date,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(4)},

        children: [
          _buildRow("Plat Nomor", plateNumber ?? "-"),
          _buildRow("Brand Kendaraan", brand ?? "-"),
          _buildRow("Model Kendaraan", model ?? "-"),
          _buildRow("Tanggal Kedatangan", date ?? "-"),
          _buildRow("Waku Kedatangan", time ?? "-"),
        ],
      ),
    );
  }

  TableRow _buildRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AppText(
            align: TextAlign.left,
            title,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AppText(
            align: TextAlign.right,
            value,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
      ],
    );
  }
}
