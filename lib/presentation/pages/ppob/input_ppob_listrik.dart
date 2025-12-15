import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/core/config/theme/app_colors.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';

import '../../widget/card/price_option.dart';

class InputPpobPage extends StatefulWidget {
  final String title;
  const InputPpobPage({super.key, required this.title});

  @override
  State<InputPpobPage> createState() => _InputPpobPageState();
}

class _InputPpobPageState extends State<InputPpobPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _prepaidController = TextEditingController();
  final TextEditingController _postpaidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: widget.title,
      scrollable: false,

      body: [
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.light.background,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.light.borderPrimary,
                  labelColor: AppColors.common.black,
                  dividerColor: Colors.transparent,

                  unselectedLabelColor: AppColors.common.black,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(text: "Token Listrik"),
                    Tab(text: "Pasca Bayar"),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TokenInputPpobView(
                      title: widget.title,
                      label: 'Nomor Meter / ID Pel',
                      hintText: "Masukan ID Pelanggan/No. Meteran",
                      controller: _prepaidController,
                    ),
                    PascaInputPpobView(
                      title: widget.title,
                      label: 'Nomor Meter / ID Pel',
                      hintText: "Masukan ID Pelanggan/No. Meteran",
                      controller: _postpaidController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TokenInputPpobView extends StatefulWidget {
  final String title;
  final String label;
  final String hintText;
  final TextEditingController controller;

  const TokenInputPpobView({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.label,
  });

  @override
  State<TokenInputPpobView> createState() => _TokenInputPpobViewState();
}

class _TokenInputPpobViewState extends State<TokenInputPpobView> {
  bool showPrice = false;
  final TextEditingController name = TextEditingController(
    text: 'PT KA*** ****MA',
  );

  int? _selectedIndex;

  final List<Map<String, String>> priceList = [
    {'label': '20Rb', 'price': 'Rp21.500'},
    {'label': '50Rb', 'price': 'Rp51.500'},
    {'label': '100Rb', 'price': 'Rp101.500'},
    {'label': '200Rb', 'price': 'Rp201.500'},
    {'label': '500Rb', 'price': 'Rp501.500'},
    {'label': '1JT', 'price': 'Rp1.001.500'},
    {'label': '5JT', 'price': 'Rp5.001.500'},
    {'label': '10JT', 'price': 'Rp10.001.500'},
  ];

  void tooglePrice() => setState(() {
    showPrice = !showPrice;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomButton(),
      body: Container(
        color: const Color(0xFFF2F8FC),
        width: double.infinity,

        child: ListView(
          children: [
            AppGap.height(16),
            AppTextFormField(
              label: widget.label,
              keyboardType: TextInputType.number,
              hintText: "Masukan ID Pelanggan/No. Meteran",
              controller: widget.controller,
            ),
            if (showPrice) ...[
              AppGap.height(16),
              AppTextFormField(
                label: widget.label,
                keyboardType: TextInputType.number,
                hintText: "Masukkan warna kendaraan",
                controller: name,
              ),
              AppGap.height(16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: priceList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = priceList[index];
                  return PriceOptionCard(
                    label: item['label']!,
                    price: item['price']!,
                    selected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,

        child: Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: showPrice ? "Lanjut" : "Periksa Nomor Pelanggan",
                onPressed: () {
                  if (showPrice) {
                    context.push('/check-taglist', extra: widget.title);
                  } else {
                    tooglePrice();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PascaInputPpobView extends StatefulWidget {
  final String title;
  final String label;

  final String hintText;
  final TextEditingController controller;

  const PascaInputPpobView({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.label,
  });

  @override
  State<PascaInputPpobView> createState() => _PascaInputPpobViewState();
}

class _PascaInputPpobViewState extends State<PascaInputPpobView> {
  final TextEditingController name = TextEditingController(
    text: 'PT KA*** ****MA',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomButton(),
      body: Container(
        color: const Color(0xFFF2F8FC),
        width: double.infinity,

        child: ListView(
          children: [
            AppGap.height(16),
            AppTextFormField(
              label: widget.label,
              keyboardType: TextInputType.number,
              hintText: "Masukan ID Pelanggan/No. Meteran",
              controller: widget.controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,

        child: Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: "Periksa Nomor Pelanggan",
                onPressed: () {
                  context.push('/check-taglist', extra: widget.title);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
