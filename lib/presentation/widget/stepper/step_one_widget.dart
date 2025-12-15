import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/model/vehicle_payload_model.dart';
import '../../../domain/entities/brand_entity.dart';
import '../../../domain/entities/mvehicle_entity.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../cubit/brand_cubit.dart';
import '../../cubit/create_new_v_cubit.dart';
import '../../cubit/create_new_v_state.dart';
import '../../cubit/model_cubit.dart';
import '../../cubit/vehicle_cust_cubit.dart';
import '../widget.dart';

// ignore: must_be_immutable
class StepOneWidget extends StatefulWidget {
  final TextEditingController platController;
  final TextEditingController colorController;

  String? vehicleType;
  String? selectedBrand;
  String? selectedModel;
  final ValueChanged<String?> onVehicleTypeChanged;
  final ValueChanged<String?> onBrandChanged;
  final ValueChanged<String?> onModelChanged;

  StepOneWidget({
    super.key,

    required this.platController,
    this.vehicleType,
    this.selectedBrand,
    this.selectedModel,
    required this.onVehicleTypeChanged,
    required this.onBrandChanged,
    required this.onModelChanged,
    required this.colorController,
  });

  @override
  State<StepOneWidget> createState() => _StepOneWidgetState();
}

class _StepOneWidgetState extends State<StepOneWidget> {
  final TextEditingController _newPlate = TextEditingController();
  final TextEditingController _newColor = TextEditingController();

  List<VehicleEntity> vehicleList = [];
  List<String> brandList = [];
  List<String> modelList = [];
  bool _isDummyDataLoaded = false;

  String? selectedPlate;
  String? selectedBrand;
  String? selectedModel;
  String? selectedColor;
  String? selectedVehicleType;

  bool isNewV = false;
  bool isformValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    selectedVehicleType = widget.vehicleType;
    selectedBrand = widget.selectedBrand;
    selectedModel = widget.selectedModel;

    if (widget.platController.text.isNotEmpty) {
      _newPlate.text = widget.platController.text;
      selectedPlate = widget.platController.text;
    }
    if (widget.colorController.text.isNotEmpty) {
      _newColor.text = widget.colorController.text;
      selectedColor = widget.colorController.text;
    }

    formValid();
  }

  void formValid() {
    isformValid = false;
    if (selectedVehicleType == null) return;
    if (_newColor.text.isEmpty) return;
    if (_newPlate.text.isEmpty) return;
    if (selectedBrand == null) return;
    if (selectedModel == null) return;

    isformValid = true;
  }

  void deleteFormVehicle() {
    isNewV = false;
    selectedBrand = null;
    selectedColor = null;
    selectedModel = null;
    selectedPlate = null;
    _newColor.text = '';
    _newPlate.text = '';
  }

  Future<List<VehicleEntity>> fetchDataVehicleDummy() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_isDummyDataLoaded) {
      vehicleList = [
        const VehicleEntity(
          id: 1,
          plateNumber: "B 1234 ABC",
          type: "Mobil",
          brand: "Toyota",
          model: "Avanza",
          color: "Hitam",
          userId: 10,
        ),
        const VehicleEntity(
          id: 2,
          plateNumber: "F 5678 DEF",
          type: "Motor",
          brand: "Honda",
          model: "Beat",
          color: "Merah",
          userId: 10,
        ),
        const VehicleEntity(
          id: 3,
          plateNumber: "B 9876 GHI",
          type: "Mobil",
          brand: "Daihatsu",
          model: "Xenia",
          color: "Putih",
          userId: 10,
        ),
        const VehicleEntity(
          id: 4,
          plateNumber: "F 1111 JKL",
          type: "Motor",
          brand: "Yamaha",
          model: "NMAX",
          color: "Abu-abu",
          userId: 10,
        ),
      ];
      _isDummyDataLoaded = true;
    }

    return vehicleList;
  }

  Future<List<String>> fetchListBrandDummy() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return ['Toyota', 'Honda', 'Daihatsu', 'Suzuki', 'Mitsubishi', 'Nissan'];
  }

  Future<List<String>> fetchListModelDummy() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return ['Alphard', 'Odessey', 'Xenia', 'Ertiga', 'Lancer', 'Ninja', 'CBR'];
  }

  Future<void> doCreateNewVehicle() async {
    log("[Tipe Kendaraan] : $selectedVehicleType");
    log("[Plat Kendaraan] : $_newPlate");
    log("[Warna Kendaraan] : $_newColor");
    log("[Brand Kendaraan] : $selectedBrand");
    log("[Model Kendaraan] : $selectedModel");
    setState(() {
      isLoading = true;
    });
    // await Future.delayed(const Duration(seconds: 2));

    final payload = VehiclePayloadModel(
      plateNumber: _newPlate.text,
      type: selectedVehicleType!,
      brand: selectedBrand!,
      model: selectedModel!,
      color: _newColor.text,
    );
    // final newVehicle = VehicleEntity(
    //   id: vehicleList.length + 1,
    //   plateNumber: payload.plateNumber,
    //   type: payload.type,
    //   brand: payload.brand,
    //   model: payload.model,
    //   color: payload.color,
    //   userId: 1,
    // );

    // vehicleList.add(newVehicle);

    setState(() {
      isLoading = false;
      isNewV = false;
    });
    deleteFormVehicle();
    showAppSnackBar(
      context,
      message: "Kendaraan berhasil ditambahkan",
      type: SnackType.success,
    );

    context.read<CreateVehicleCubit>().createVehicle(payload);
  }

  void toogleAddVehicle() {
    setState(() {
      isNewV = !isNewV;
    });
  }

  void _showBrandBottomSheet(BuildContext context) {
    final brandCubit = context.read<BrandCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicSelectionBottomSheet<BrandEntity>(
          searchHint: "Cari Brand Kendaraan",

          onFetchData: () async {
            final result = await brandCubit.fetchListBrand.execute(
              selectedVehicleType ?? '',
            );

            return result.fold((failure) {
              throw Exception(failure);
            }, (brands) => brands);
          },
          itemLabel: (item) => item.name,
          onItemSelected: (selected) {
            widget.onBrandChanged(selected.name);
            selectedBrand = selected.name;
            formValid();
          },
        );
      },
    );
  }

  void _showModelBottomSheet(BuildContext context) {
    final modelCubit = context.read<ModelCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicSelectionBottomSheet<MVehicleEntity>(
          searchHint: "Cari Model Kendaraan",
          // onFetchData: () async {
          //   return fetchListModelDummy();
          // },
          onFetchData: () async {
            final result = await modelCubit.fetchListModel.execute(
              brand: selectedBrand ?? 'Honda',
              vType: selectedVehicleType ?? 'car',
            );

            return result.fold((failure) {
              throw Exception(failure);
            }, (models) => models);
          },
          itemLabel: (item) => item.name,
          onItemSelected: (selected) {
            widget.onBrandChanged(selected.name);
            selectedModel = selected.name;

            formValid();
          },
        );
      },
    );
  }

  void _showPlateBottomSheet(BuildContext context) {
    final vehicleCubit = context.read<VehicleCustCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicSelectionBottomSheet<VehicleEntity>(
          searchHint: "Cari Plat Nomor",

          onFetchData: () async {
            final result = await vehicleCubit.fetchListVehicleCust.execute();

            return result.fold((failure) => throw Exception(failure), (
              vehicles,
            ) {
              vehicleList = vehicles;
              return vehicles;
            });
            // if (useDummy) {

            //   vehicleList = await fetchDataVehicleDummy();
            //   return vehicleList;
            // } else {

            //   final result = await vehicleCubit.fetchListVehicleCust.execute();

            //   return result.fold((failure) => throw Exception(failure), (
            //     vehicles,
            //   ) {
            //     vehicleList = vehicles;
            //     return vehicles;
            //   });
            // }
          },

          itemLabel: (item) => item.plateNumber,

          onItemSelected: (selected) {
            setState(() {
              selectedPlate = selected.plateNumber;
              selectedBrand = selected.brand;
              selectedModel = selected.model;
              selectedColor = selected.color;
              selectedVehicleType = selected.type;

              widget.platController.text = selectedPlate ?? '';
              widget.colorController.text = selectedColor ?? '';

              widget.onBrandChanged(selectedBrand);
              widget.onModelChanged(selectedModel);
              widget.onVehicleTypeChanged(selectedVehicleType);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateVehicleCubit, CreateVehicleState>(
      listener: (context, state) {
        if (state is CreateVehicleSuccess) {
          showAppSnackBar(
            context,
            message: "Kendaraan berhasil ditambahkan",
            type: SnackType.success,
          );
          deleteFormVehicle();
        } else if (state is CreateVehicleError) {
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
      },
      builder: (context, state) {
        // final isLoading = state is CreateVehicleLoading;

        return StepBaseWidget(
          currentStep: 1,
          totalSteps: 4,

          children: [
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(
                        'Plat Nomor Kendaraan',
                        variant: TextVariant.body2,
                        weight: TextWeight.medium,
                      ),
                    ],
                  ),
                  AppGap.height(8),
                  GestureDetector(
                    onTap: () => _showPlateBottomSheet(context),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppBox(
                            borderRadius: 8,
                            color: AppColors.common.white,
                            child: Padding(
                              padding: AppPadding.all(15),
                              child: AppText(
                                align: TextAlign.left,
                                selectedPlate ??
                                    'Pilih plat nomor kendaraan anda',
                                variant: TextVariant.body2,
                                color: selectedPlate != null
                                    ? AppColors.common.black
                                    : AppColors.common.grey400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppGap.height(16),

                  if (selectedBrand != null && selectedModel != null) ...[
                    AppText(
                      "Merek: $selectedBrand",
                      variant: TextVariant.body2,
                    ),
                    AppText(
                      "Model: $selectedModel",
                      variant: TextVariant.body2,
                    ),
                    AppText(
                      "Warna: $selectedColor",
                      variant: TextVariant.body2,
                    ),
                  ],
                ],
              ),

              crossFadeState: isNewV
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),

            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VehicleTypeSelector(
                    onChanged: (value) {
                      setState(() {
                        selectedVehicleType = value;
                      });

                      formValid();
                    },
                  ),
                  AppGap.height(12),
                  AppTextFormField(
                    label: "Masukan Plat Kendaraan Baru",
                    hintText: "Masukkan plat kendaraan",
                    controller: _newPlate,
                    onChanged: (value) {
                      formValid();
                      selectedPlate = _newPlate.text;
                    },
                  ),
                  AppGap.height(12),
                  AppTextFormField(
                    label: "Masukan Warna Kendaraan Baru",
                    hintText: "Masukkan warna kendaraan",
                    controller: _newColor,
                    onChanged: (value) {
                      formValid();
                    },
                  ),
                  AppGap.height(12),

                  Row(
                    children: [
                      AppText(
                        'Pilih Brand Kendaraan',
                        variant: TextVariant.body2,
                        weight: TextWeight.medium,
                      ),
                    ],
                  ),
                  AppGap.height(8),
                  GestureDetector(
                    onTap: () => selectedVehicleType != null
                        ? _showBrandBottomSheet(context)
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppBox(
                            borderRadius: 8,
                            color: AppColors.common.white,
                            child: Padding(
                              padding: AppPadding.all(15),
                              child: AppText(
                                align: TextAlign.left,

                                selectedVehicleType == null
                                    ? "Pilih tipe kendaraan terlebih dahulu"
                                    : (selectedBrand != null &&
                                              selectedBrand!.isNotEmpty
                                          ? selectedBrand!
                                          : "Pilih brand kendaraan anda"),
                                variant: TextVariant.body2,
                                color: selectedBrand != null
                                    ? AppColors.common.black
                                    : AppColors.common.grey400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppGap.height(12),

                  Row(
                    children: [
                      AppText(
                        selectedBrand != null
                            ? 'Pilih Model Kendaraan'
                            : 'Pilih brand kendaraan terlebih dahulu',
                        variant: TextVariant.body2,
                        weight: TextWeight.medium,
                      ),
                    ],
                  ),
                  AppGap.height(8),
                  GestureDetector(
                    onTap: () => selectedBrand != null
                        ? _showModelBottomSheet(context)
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppBox(
                            borderRadius: 8,
                            color: AppColors.common.white,
                            child: Padding(
                              padding: AppPadding.all(15),
                              child: AppText(
                                align: TextAlign.left,
                                selectedBrand == null
                                    ? "Pilih brand kendaraan terlebih dahulu"
                                    : (selectedModel != null &&
                                              selectedModel!.isNotEmpty
                                          ? selectedModel!
                                          : "Pilih model kendaraan anda"),

                                variant: TextVariant.body2,
                                color: selectedModel != null
                                    ? AppColors.common.black
                                    : AppColors.common.grey400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppGap.height(12),
                  AppElevatedButton(
                    text: isLoading ? "Menyimpan..." : "Simpan Kendaraan",
                    onPressed: !isformValid || isLoading
                        ? null
                        : () => doCreateNewVehicle(),
                    height: 40,
                  ),
                ],
              ),
              crossFadeState: isNewV
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            AppGap.height(12),
            AppOutlineButton(
              text: isNewV ? 'Batalkan' : 'Tambah Kendaraan Baru',
              buttonColor: isNewV ? AppColors.light.error : null,
              height: 40,
              onPressed: () {
                toogleAddVehicle();
                selectedBrand = null;
                selectedPlate = null;
                selectedColor = null;
                selectedModel = null;
                _newColor.text = '';
                _newPlate.text = '';
              },
            ),
          ],
        );
      },
    );
  }
}
