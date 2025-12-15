import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../data/dummy/dummy_payment_method.dart';
import '../../../data/model/payment_method.dart';
import '../payment_method.dart/select_payment_method.dart';

class CheckAssurancePage extends StatefulWidget {
  const CheckAssurancePage({super.key});

  @override
  State<CheckAssurancePage> createState() => _CheckAssurancePageState();
}

class _CheckAssurancePageState extends State<CheckAssurancePage> {
  PaymentMethod? _selectedPaymentMethod;

  void pay() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.common.white,
        title: const Text("Konfirmasi Pembayaran"),
        content: const Text("Apakah Anda yakin ingin melakukan pembayaran?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              context.push('/payment-information');
            },
            child: const Text("Bayar Sekarang"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: "Asuransi",
      bottomNavigationBar: _buildBottomButton(),
      scrollable: true,
      body: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
          ),
          child: Table(
            columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(4)},

            children: [
              _buildRow("Nomor VA", "131214124"),
              _buildRow("Nama", "Keiko"),
            ],
          ),
        ),
        AppGap.height(12),
        _buildPaymentMethodCard(),
        AppGap.height(12),
        _buildPaymentDetailCard(),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod != null ? () => pay() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FA4B8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Bayar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return _buildOptionCard(
      icon: Icons.payment_outlined,
      title: _selectedPaymentMethod?.name ?? "Metode Pembayaran",

      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SelectPaymentMethodPage(methods: dummyPaymentMethods),
          ),
        );

        if (result != null && result is PaymentMethod) {
          setState(() {
            _selectedPaymentMethod = result;
          });
        }
      },
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.light.primary),
            AppGap.width(12),
            AppText(
              title,
              weight: TextWeight.medium,
              variant: TextVariant.body3,
            ),
            Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long, color: Colors.teal),
              SizedBox(width: 8),
              AppText(
                "Rincian Pembayaran",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),
            ],
          ),
          const SizedBox(height: 12),

          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildRow('Subtotal', 'Rp20.000'),
              _buildRow('Biaya Admin', 'Rp1.500'),
            ],
          ),
          const Divider(),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
            },
            children: [_buildRow('Total Pembayaran', 'Rp21.500')],
          ),
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
