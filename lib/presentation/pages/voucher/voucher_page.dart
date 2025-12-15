import 'package:flutter/material.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.background,
      body: Center(child: Text("Voucher")),
    );
  }
}
