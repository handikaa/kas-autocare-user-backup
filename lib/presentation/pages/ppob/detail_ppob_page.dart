import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/assets/app_images.dart';
import '../../../core/config/theme/app_text_style.dart';

class DetailPpobPage extends StatefulWidget {
  final String status;
  final String title;
  const DetailPpobPage({super.key, required this.status, required this.title});

  @override
  State<DetailPpobPage> createState() => _DetailPpobPageState();
}

class _DetailPpobPageState extends State<DetailPpobPage> {
  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: 'Detail Transaksi',
      scrollable: true,
      body: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.common.white,

            borderRadius: BorderRadius.circular(12),
          ),
          padding: AppPadding.all(12),
          child: Column(
            children: [
              AppGap.height(12),
              Image(image: AssetImage(AppImages.logoTeks), width: 140),
              Image(
                image: AssetImage(
                  widget.status.toLowerCase() == 'berhasil'
                      ? AppIcons.successIcon
                      : widget.status.toLowerCase() == 'gagal'
                      ? AppIcons.failedIcon
                      : AppIcons.warningIcon,
                ),
                width: 140,
              ),
              AppText(
                widget.status.toLowerCase() == 'berhasil'
                    ? "Pembayaran Berhasil"
                    : widget.status.toLowerCase() == 'gagal'
                    ? "Pembayaran Gagal"
                    : "Pembayaran Sedang di Proses",
                variant: TextVariant.body1,
                weight: TextWeight.medium,
              ),
              AppGap.height(12),
              AppText(
                "25 Maret 2025 07:30:17 WIB",
                variant: TextVariant.body3,
                weight: TextWeight.medium,
              ),
              if (widget.title.toLowerCase().contains('listrik')) ...[
                AppGap.height(12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.light.primary30,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AppText(
                            "No Token",
                            variant: TextVariant.body2,
                            weight: TextWeight.medium,
                          ),
                        ],
                      ),
                      AppGap.height(6),
                      Row(
                        children: [
                          AppText(
                            "1234 1234 1234 1234 1234",
                            variant: TextVariant.body1,
                            weight: TextWeight.bold,
                          ),
                          Spacer(),
                          Icon(Icons.copy),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              AppGap.height(24),

              Row(
                children: [
                  AppText(
                    widget.title,
                    variant: TextVariant.body2,
                    weight: TextWeight.bold,
                  ),
                ],
              ),
              AppGap.height(8),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(2),
                },
                children: [
                  buildTableRow('No Pelanggan', '322040438901231'),
                  buildTableRow('Nama Pelanggan', 'Ald**** ****nsa'),
                  if (widget.title.toLowerCase().contains('listrik'))
                    buildTableRow('Tarif Listrik', 'R1 / 1300 VA'),
                  if (widget.title.toLowerCase().contains('pdam'))
                    buildTableRow('Wilayah', 'Aceh, Daroy'),
                ],
              ),

              AppGap.height(24),
              DashedDivider(
                color: AppColors.common.black,
                height: 1,
                dashWidth: 12,
                dashSpace: 6,
              ),
              AppGap.height(24),
              Row(
                children: const [
                  Icon(Icons.receipt_long, color: Colors.teal),
                  SizedBox(width: 8),
                  Text(
                    'Rincian Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              AppGap.height(12),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(2),
                },
                children: [
                  buildTableRow('Sub Total', 'Rp1.300.100'),
                  buildTableRow('Biaya Admin', 'Rp450.000'),
                ],
              ),
              AppGap.height(12),
              DashedDivider(
                color: AppColors.common.black,
                height: 1,
                dashWidth: 12,
                dashSpace: 6,
              ),
              AppGap.height(12),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(2),
                },
                children: [buildTableRow('Total Pembayaran', 'Rp2.551.100')],
              ),
              AppGap.height(68),
              AppText(
                "KAS autocare | Copyright 2025 | All right reserved.",
                variant: TextVariant.body3,
                weight: TextWeight.medium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow buildTableRow(
    String label,
    String value, {

    Color? labelColor,
    FontWeight? valueWeight,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(
            label,
            align: TextAlign.left,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(
            value,
            align: TextAlign.right,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
      ],
    );
  }
}
