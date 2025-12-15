import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../text/app_text.dart';

class CarwashTabel extends StatelessWidget {
  final String? name;
  final String? location;
  final String? urlLocation;

  const CarwashTabel({super.key, this.location, this.name, this.urlLocation});

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
          _buildRow("Nama Carwash", name ?? "-"),
          _buildRow("Lokasi", location ?? "-"),
          // _buildRow("Lihat Lokasi", urlLocation ?? "-"),
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
          child: title == "Lihat Lokasi" && value != "-"
              ? GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(value);
                    try {
                      final bool launched = await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        debugPrint("Tidak dapat membuka URL: $url");
                      }
                    } catch (e) {
                      debugPrint("Error saat membuka URL: $e");
                    }
                  },

                  child: AppText(
                    align: TextAlign.right,
                    'Telusuri',
                    variant: TextVariant.body2,
                    weight: TextWeight.medium,
                    color: AppColors.light.mainBlue,
                  ),
                )
              : AppText(
                  maxLines: 4,
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
