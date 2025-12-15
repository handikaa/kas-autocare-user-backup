import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../widget/widget.dart';

class InputAssurancePage extends StatefulWidget {
  final String assurance;
  const InputAssurancePage({super.key, required this.assurance});

  @override
  State<InputAssurancePage> createState() => _InputAssurancePageState();
}

class _InputAssurancePageState extends State<InputAssurancePage> {
  final TextEditingController _vaController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool get _isFormValid =>
      _vaController.text.trim().isNotEmpty &&
      _amountController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _vaController.addListener(() {
      final text = _vaController.text.replaceAll(' ', '');
      final formatted = _formatVA(text);
      if (formatted != _vaController.text) {
        _vaController.value = _vaController.value.copyWith(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
      setState(() {});
    });

    _amountController.addListener(() {
      final text = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final formatted = _formatCurrency(text);
      if (formatted != _amountController.text) {
        _amountController.value = _amountController.value.copyWith(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
      setState(() {});
    });
  }

  String _formatVA(String value) {
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);
      final index = i + 1;
      if (index % 4 == 0 && index != value.length) buffer.write(' ');
    }
    return buffer.toString();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(int.parse(value)).replaceAll(',', '.');
  }

  void _saveAssurance() {
    context.push('/check-assurance');
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      usePadding: false,
      bottomNavigationBar: _buildBottomButton(),
      title: 'Asuransi',
      scrollable: true,
      body: [
        Padding(
          padding: AppPadding.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderAssurance(),
              const SizedBox(height: 24),
              const Text(
                "Nomor Virtual Account",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildFormVA(),
              const SizedBox(height: 24),
              const Text(
                "Nominal Pembayaran",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildFormAmount(),
              const SizedBox(height: 8),
              const Text(
                "Masukan Nominal Sesuai Tagihan Kamu",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderAssurance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.business, color: Colors.red),
            const SizedBox(width: 12),
            Text(
              widget.assurance,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      ],
    );
  }

  Widget _buildFormVA() {
    return TextField(
      controller: _vaController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Masukkan Nomor Virtual Account",
        suffixIcon: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.grey),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Nomor VA biasanya tertera pada tagihan asuransi kamu.',
                ),
              ),
            );
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildFormAmount() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 4, top: 0),
          child: Text(
            "Rp",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                onPressed: _isFormValid ? _saveAssurance : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FA4B8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Lanjut",
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
}
