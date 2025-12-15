import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';

import '../../../data/dummy/dummy_payment_method.dart';
import '../../../data/model/payment_method.dart';
import '../../widget/widget.dart';
import '../payment_method.dart/select_payment_method.dart';

class CheckTaglistPage extends StatefulWidget {
  final String title;

  const CheckTaglistPage({super.key, required this.title});

  @override
  State<CheckTaglistPage> createState() => _CheckTaglistPageState();
}

class _CheckTaglistPageState extends State<CheckTaglistPage> {
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
      bottomNavigationBar: _buildBottomButton(),
      title: widget.title,
      scrollable: true,
      body: [
        const SizedBox(height: 16),
        _buildInfoCard(),
        const SizedBox(height: 16),
        _buildPaymentMethodCard(),
        const SizedBox(height: 16),
        _buildPaymentDetailCard(),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,
        padding: AppPadding.all(16),
        child: Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: "Bayar",
                onPressed: () {
                  pay();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.title.toLowerCase() == "token listrik"
                      ? 'assets/images/pln_logo.png'
                      : 'assets/images/pdam.png',
                  width: 40,
                  height: 40,
                ),
              ),
              AppGap.width(8),
              Text(
                widget.title,
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
              buildTableRow('No Pelanggan', '32204043890'),
              buildTableRow('Nama Pelanggan', 'PT. ******** ****** B'),
              if (widget.title.toLowerCase() == 'token listrik') ...[
                buildTableRow('Tarif Listrik', 'R1 / 1300 VA'),
              ],
              if (widget.title.toLowerCase() == 'air pdam') ...[
                buildTableRow('Wilayah', 'Jawa Barat, Kota Bogor'),
                buildTableRow('Alamat', 'Villa Bogor Indah 5'),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),

          // Harga
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Harga',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  'Rp130.000',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
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
              variant: TextVariant.body2,
            ),
            Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
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
              Text(
                'Rincian Pembayaran',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
              buildTableRow('Subtotal', 'Rp20.000'),
              buildTableRow('Biaya Admin', 'Rp1.500'),
            ],
          ),
          const Divider(),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
            },
            children: [buildTableRow('Total Pembayaran', 'Rp21.500')],
          ),
        ],
      ),
    );
  }
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
