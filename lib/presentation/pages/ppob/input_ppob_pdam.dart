import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../widget/widget.dart';

class InputPpobPdam extends StatefulWidget {
  final String title;
  const InputPpobPdam({super.key, required this.title});

  @override
  State<InputPpobPdam> createState() => _InputPpobPdamState();
}

class _InputPpobPdamState extends State<InputPpobPdam> {
  String? selectedProvince;
  String? selectedPeneydia;
  final TextEditingController _custNumber = TextEditingController();

  Future<List<String>> fetchListProvinsiDummy() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // simulasi delay API
    return [
      "Aceh",
      "Sumatera Utara",
      "Sumatera Barat",
      "Riau",
      "Jambi",
      "Sumatera Selatan",
      "Bengkulu",
      "Lampung",
      "Kepulauan Bangka Belitung",
      "Kepulauan Riau",
      "DKI Jakarta",
      "Jawa Barat",
      "Jawa Tengah",
      "DI Yogyakarta",
      "Jawa Timur",
      "Banten",
      "Bali",
      "Nusa Tenggara Barat",
      "Nusa Tenggara Timur",
      "Kalimantan Barat",
      "Kalimantan Tengah",
      "Kalimantan Selatan",
      "Kalimantan Timur",
      "Kalimantan Utara",
      "Sulawesi Utara",
      "Sulawesi Tengah",
      "Sulawesi Selatan",
      "Sulawesi Tenggara",
      "Gorontalo",
      "Sulawesi Barat",
      "Maluku",
      "Maluku Utara",
      "Papua",
      "Papua Barat",
      "Papua Tengah",
      "Papua Pegunungan",
      "Papua Selatan",
      "Papua Barat Daya",
    ];
  }

  Future<List<String>> fetchListPenyediaDummy() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      "Daroy\n(PDAM Tirta Daroy)",
      "Kab. Aceh Tenggara\n(PDAM Aceh Tenggara)",
      "Kab. Aceh Barat\n(PDAM Tirta Meulaboh)",
      "Kab. Aceh Barat Daya\n(PDAM Kabupaten Aceh Barat Daya)",
      "Kab. Aceh Besar\n(PDAM Tirta Mountala Aceh Besar)",
      "Kab. Aceh Jaya\n(PDAM Kabupaten Aceh Jaya)",
    ];
  }

  void _showBottomSheetProvince(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicSelectionBottomSheet<String>(
          searchHint: "Cari Provinsi",
          onFetchData: () async {
            return fetchListProvinsiDummy();
          },
          itemLabel: (item) => item,
          onItemSelected: (selected) {
            setState(() {
              selectedProvince = selected;
            });
          },
        );
      },
    );
  }

  void _showBottomSheetPenyedia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicSelectionBottomSheet<String>(
          searchHint: "Cari Nama Penyedia",
          onFetchData: () async {
            return fetchListPenyediaDummy();
          },
          itemLabel: (item) => item,
          onItemSelected: (selected) {
            setState(() {
              selectedPeneydia = selected;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: widget.title,
      scrollable: false,
      bottomNavigationBar: _buildBottomButton(),
      body: [
        Row(
          children: [
            AppText(
              'Pilih Provinsi',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        GestureDetector(
          onTap: () => _showBottomSheetProvince(context),

          child: Row(
            children: [
              Expanded(
                child: AppBox(
                  borderRadius: 8,
                  useBorder: true,
                  color: AppColors.common.white,
                  child: Padding(
                    padding: AppPadding.all(15),
                    child: AppText(
                      selectedProvince == null
                          ? "Pilih Provinsi"
                          : selectedProvince!,
                      align: TextAlign.left,

                      variant: TextVariant.body2,
                      color: selectedProvince != null
                          ? AppColors.common.black
                          : AppColors.common.grey400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppGap.height(18),
        Row(
          children: [
            AppText(
              'Pilih Penyedia',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        GestureDetector(
          onTap: () => _showBottomSheetPenyedia(context),

          child: Row(
            children: [
              Expanded(
                child: AppBox(
                  useBorder: true,
                  borderRadius: 8,
                  color: AppColors.common.white,
                  child: Padding(
                    padding: AppPadding.all(15),
                    child: AppText(
                      selectedPeneydia == null
                          ? "Pilih Penyedia"
                          : selectedPeneydia!,
                      align: TextAlign.left,

                      variant: TextVariant.body2,
                      color: selectedPeneydia != null
                          ? AppColors.common.black
                          : AppColors.common.grey400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppGap.height(18),
        AppTextFormField(
          label: "Nomor Pelanggan",
          keyboardType: TextInputType.number,
          hintText: "Isi Nomor Pelanggan ",
          controller: _custNumber,
        ),
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
                text: "Lanjut",
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
