import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';

import '../../widget/widget.dart';

class AssurancePage extends StatefulWidget {
  const AssurancePage({super.key});

  @override
  State<AssurancePage> createState() => _AssurancePageState();
}

class _AssurancePageState extends State<AssurancePage> {
  final TextEditingController _findAssurance = TextEditingController();

  // Data dummy penyedia asuransi
  final List<Map<String, String>> _assurances = [
    {
      "name": "AIA",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/8/8a/AIA_logo.svg",
    },
    {
      "name": "AJ CAR 23222",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/d/d0/CAR_logo.svg",
    },
    {
      "name": "AJ CAR 23777",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/d/d0/CAR_logo.svg",
    },
    {
      "name": "Askrindo",
      "logo":
          "https://upload.wikimedia.org/wikipedia/commons/8/8c/Askrindo_logo.svg",
    },
  ];

  List<Map<String, String>> _filteredAssurances = [];

  @override
  void initState() {
    super.initState();
    _filteredAssurances = _assurances;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAssurances = _assurances;
      } else {
        _filteredAssurances = _assurances
            .where(
              (item) =>
                  item['name']!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: 'Asuransi',
      scrollable: true,
      body: [
        AppSearchForm(
          hintText: "Cari Nama Penyedia",
          controller: _findAssurance,
          onSearch: () => _onSearchChanged(_findAssurance.text),
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 12),
        ..._filteredAssurances.map(
          (assurance) => AssuranceCard(
            name: assurance['name']!,
            logoUrl: assurance['logo']!,
            onTap: () {
              context.push('/input-assurance');
            },
          ),
        ),
      ],
    );
  }
}

class AssuranceCard extends StatelessWidget {
  final String name;
  final String logoUrl;
  final VoidCallback onTap;

  const AssuranceCard({
    super.key,
    required this.name,
    required this.logoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.common.black),
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  logoUrl,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, _, __) =>
                      const Icon(Icons.business, size: 32),
                ),
              ),
              AppGap.width(12),
              Expanded(
                child: AppText(
                  align: TextAlign.left,
                  name,
                  variant: TextVariant.body2,
                  weight: TextWeight.medium,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
