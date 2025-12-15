import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

class PpobPage extends StatefulWidget {
  const PpobPage({super.key});

  @override
  State<PpobPage> createState() => _PpobPageState();
}

class _PpobPageState extends State<PpobPage> {
  final TextEditingController _findLayanan = TextEditingController();

  final List<Map<String, dynamic>> _services = [
    {
      "name": "Token Listrik",
      "icon": Icons.bolt,
      "tag": "listrik,token,pln",
      'route': '/input-ppob-listrik',
    },
    {
      "name": "Air PDAM",
      "icon": Icons.water_drop,
      "tag": "air,pdam",
      'route': '/input-ppob-pdam',
    },
    {
      "name": "Tiket Pesawat",
      "icon": Icons.flight,
      "tag": "pesawat,tiket,travel",
      'route': '/input-ppob-listrik',
    },
    {
      "name": "Asuransi",
      "icon": Icons.assignment,
      "tag": "asuransi,insurance",
      'route': '/assurance',
    },
    {
      "name": "Top Up E Money",
      "icon": Icons.credit_card,
      "tag": "topup,emoney,saldo",
      'route': '/input-ppob-listrik',
    },
    {
      "name": "Pulsa",
      "icon": Icons.phone_android,
      "tag": "pulsa,telepon,hp",
      'route': '/input-ppob-listrik',
    },
    {
      "name": "Internet",
      "icon": Icons.wifi,
      "tag": "internet,data",
      'route': '/input-ppob-listrik',
    },
    {
      "name": "BPJS",
      "icon": Icons.local_hospital,
      "tag": "bpjs,kesehatan",
      'route': '/input-ppob-listrik',
    },
  ];

  String _searchQuery = "";

  List<Map<String, dynamic>> get _filteredServices {
    if (_searchQuery.isEmpty) return _services;
    return _services
        .where(
          (item) =>
              item["name"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item["tag"].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: 'Pulsa, Tagihan, Pembayaran',
      scrollable: true,
      body: [
        AppSearchForm(
          hintText: "Cari Layanan",
          controller: _findLayanan,

          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),

        AppGap.height(22),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredServices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = _filteredServices[index];
            return _buildServiceItem(item);
          },
        ),
      ],
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => context.push(item['route'], extra: item['name'] as String),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.light.borderPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(item["icon"], color: AppColors.light.primary, size: 30),
          ),
          AppGap.height(6),
          Text(
            item["name"],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
