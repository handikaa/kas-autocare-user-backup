import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/domain/entities/package_entity.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

import '../../../domain/entities/service_entity.dart';

class RincianPesananCard extends StatelessWidget {
  final PackageEntity paketUtama;

  final int hargaUtama;
  final List<ServiceEntity> layananTambahan;
  final int totalPembayaran;
  final bool isKasPlusSelected;
  final bool isCard;

  const RincianPesananCard({
    super.key,
    required this.paketUtama,

    required this.hargaUtama,
    required this.layananTambahan,
    required this.totalPembayaran,
    required this.isKasPlusSelected,
    this.isCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final facilityName =
        paketUtama.variantTypes.isNotEmpty &&
            paketUtama.variantTypes.first.variants.isNotEmpty
        ? paketUtama.variantTypes.first.variants.first.facility
        : "";

    return Container(
      padding: isCard ? EdgeInsets.all(16) : null,
      decoration: isCard
          ? BoxDecoration(
              color: const Color(0xFFF8FCFF),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: AppColors.light.primary),
              AppGap.width(8),
              AppText(
                'Rincian Pesanan',
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
            ],
          ),
          AppGap.height(12),

          AppText(
            'Paket Pencucian',
            variant: TextVariant.body2,
            weight: TextWeight.semiBold,
          ),

          AppGap.height(12),

          AppBox(
            borderRadius: 8,
            color: AppColors.light.primary30,
            child: Padding(
              padding: AppPadding.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      "${paketUtama.name} $facilityName",
                      maxLines: 3,
                      align: TextAlign.left,
                      variant: TextVariant.body2,
                      weight: TextWeight.medium,
                      color: AppColors.common.black,
                    ),
                  ),
                  AppGap.width(12),
                  AppText(
                    TextFormatter.formatRupiah(hargaUtama),

                    variant: TextVariant.body2,
                    weight: TextWeight.medium,
                    color: AppColors.common.black,
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 28, color: AppColors.common.black),

          if (layananTambahan.isNotEmpty) ...[
            AppText(
              'Layanan Tambahan',
              variant: TextVariant.body2,
              weight: TextWeight.semiBold,
            ),
            AppGap.height(4),
          ],
          ...layananTambahan.map(
            (item) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        align: TextAlign.left,
                        item.name,
                        variant: TextVariant.body2,
                        weight: TextWeight.medium,
                      ),
                    ),
                    AppText(
                      align: TextAlign.right,
                      "Rp${item.price.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                      variant: TextVariant.body2,
                      weight: TextWeight.medium,
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isKasPlusSelected) ...[
            AppGap.height(4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  "Kas Plus (Prioritas)",
                  variant: TextVariant.body2,
                  weight: TextWeight.medium,
                  color: AppColors.common.black,
                ),
                AppText(
                  "Rp10.000",
                  variant: TextVariant.body2,
                  weight: TextWeight.medium,
                  color: AppColors.common.black,
                ),
              ],
            ),
          ],

          if (layananTambahan.isNotEmpty || isKasPlusSelected)
            Divider(height: 28, color: AppColors.common.black),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                align: TextAlign.left,
                "Total Pembayaran",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
              AppText(
                align: TextAlign.right,
                "Rp${totalPembayaran.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
