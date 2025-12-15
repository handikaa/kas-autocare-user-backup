import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';

import '../../../data/model/payment_method.dart';
import '../../widget/widget.dart';

class SelectPaymentMethodPage extends StatefulWidget {
  final List<PaymentMethod> methods;

  const SelectPaymentMethodPage({super.key, required this.methods});

  @override
  State<SelectPaymentMethodPage> createState() =>
      _SelectPaymentMethodPageState();
}

class _SelectPaymentMethodPageState extends State<SelectPaymentMethodPage> {
  PaymentMethod? _selectedMethod;

  void _selectMethod(PaymentMethod method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  void _confirmSelection() {
    if (_selectedMethod != null) {
      Navigator.pop(context, _selectedMethod);
    }
  }

  Widget _buildMethodCard(PaymentMethod method) {
    final isSelected = _selectedMethod?.code == method.code;
    return InkWell(
      onTap: () => _selectMethod(method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.light.background : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Image.network(method.icon, scale: 32),
            // Icon(
            //   method.icon,
            //   size: 32,
            //   color: isSelected ? Colors.teal : Colors.black54,
            // ),
            AppGap.width(12),
            AppText(
              method.name,
              variant: TextVariant.body2,
              weight: TextWeight.semiBold,
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _buildBottomButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: "Pilih",
                onPressed: _selectedMethod != null ? _confirmSelection : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: "Pilih Metode Pembayaran",
      scrollable: true,
      bottomNavigationBar: _buildBottomButton(),
      body: [
        ...widget.methods.map((method) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMethodCard(method),
          );
        }),
      ],
    );
  }
}
