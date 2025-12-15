import 'dart:convert';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/model/payment_data.dart';
import '../../../data/params/booking_payload.dart';
import '../../../domain/entities/merchant_entity.dart';
import '../../../domain/entities/package_entity.dart';
import '../../../domain/entities/service_entity.dart';
import '../../cubit/create_booking_cubit.dart';
import '../../widget/bottomsheet/wording_bottomsheet.dart';
import '../../widget/button/app_elevated_button.dart';
import '../../widget/button/app_outline_button.dart';
import '../../widget/layout/container_screen.dart';
import '../../widget/layout/size.dart';
import '../../widget/layout/spacing.dart';
import '../../widget/stepper/stepper.dart';
import '../../widget/text/app_text.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  CreateBookingCubit get createBookingCubit =>
      context.read<CreateBookingCubit>();

  int currentStep = 0;
  int totalSteps = 4;

  // Step 1 data
  final TextEditingController platController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  String? vehicleType;
  String? selectedBrand;
  String? selectedModel;
  // 🔹 Step 2 data
  MerchantEntity? selectedMerchant;
  String? selectedCity;

  // 🔹 Data step 3
  PackageEntity? selectedPackage;
  List<ServiceEntity> selectedServices = [];
  DateTime? selectedDate;
  String? selectedHour;
  bool? isKasPlusSelected;

  void resetStep3() {
    setState(() {
      selectedPackage = null;
      selectedServices = [];
      selectedDate = null;
      selectedHour = null;
    });
  }

  void nextStep() {
    switch (currentStep) {
      case 0:
        if (platController.text.isEmpty) {
          return;
        }
        break;
      case 1:
        if (selectedMerchant == null) {
          return;
        }
        break;
      case 2:
        if (selectedPackage == null ||
            selectedDate == null ||
            selectedHour == null) {
          return;
        }
        break;
    }

    if (currentStep < totalSteps - 1) {
      setState(() => currentStep++);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  void _onStepThreeCompleted({
    PackageEntity? package,
    List<ServiceEntity>? selectedServices,
    DateTime? date,
    String? hour,
  }) {
    setState(() {
      selectedPackage = package;
      this.selectedServices = selectedServices ?? [];
      selectedDate = date;
      selectedHour = hour;
    });
  }

  void pay() {
    if (selectedMerchant == null ||
        selectedPackage == null ||
        selectedDate == null ||
        selectedHour == null) {
      showAppSnackBar(
        context,
        message: 'Data belum lengkap',
        type: SnackType.error,
      );
      return;
    }

    final VariantTypeEntity? selectedVariantType =
        selectedPackage?.variantTypes.isNotEmpty == true
        ? selectedPackage!.variantTypes.first
        : null;

    final VariantEntity? selectedVariant =
        selectedVariantType?.variants.isNotEmpty == true
        ? selectedVariantType!.variants.first
        : null;

    final payload = BookingPayload(
      userId: 384,

      branchId: selectedMerchant?.id ?? 0,
      bussinesId: selectedMerchant?.bussinesId ?? 0,
      bussinesUnitId: selectedMerchant?.bussinesUnitId ?? 0,

      // selectedMerchant?.bussinesUnitId ?? 0,
      licensePlate: platController.text,
      vehicleType: vehicleType ?? "",
      brand: selectedBrand ?? "",
      model: selectedModel ?? "",
      color: colorController.text,
      serviceNewsId: selectedServices.map((e) => e.id).toList(),
      packageNewsId: selectedPackage!.id,
      scheduleDate: selectedDate!,
      scheduleTime: selectedHour!,
      isKasPlus: isKasPlusSelected ?? false,
      variantNewsId: selectedVariant?.id ?? 0,
    );

    debugPrint("===== Booking PAYLOAD =====");
    debugPrint(const JsonEncoder.withIndent('  ').convert(payload.toJson()));
    debugPrint("============================");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.common.white,
        title: Text(
          "Konfirmasi Booking",
          style: TextStyle(color: AppColors.common.black),
        ),
        content: Text(
          "Apakah Anda yakin ingin melakukan booking?",
          style: TextStyle(color: AppColors.common.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Batal",
              style: TextStyle(color: AppColors.light.error),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.light.primary,
              foregroundColor: AppColors.common.white,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.pop();
              doBooking(context, payload);
            },
            child: Text(
              "Bayar Sekarang",
              style: TextStyle(color: AppColors.common.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doBooking(BuildContext ctx, BookingPayload payload) async {
    await createBookingCubit.createVehicle(payload);
  }

  @override
  void dispose() {
    platController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateBookingCubit, CreateBookingState>(
      listener: (context, state) {
        if (state is CreateBookingLoading) {
          AppDialog.loading(context, message: "Membuat booking...");
        } else if (state is CreateBookingSuccess) {
          Navigator.pop(context);
          showAppSnackBar(
            context,
            message: "Berhasil Membuat Booking",
            type: SnackType.success,
          );

          PaymentData dataPayment = PaymentData(
            id: state.data,
            type: 'service',
          );
          context.go('/payment-information', extra: dataPayment);

          // setState(() {
          //   currentStep = 0;
          //   selectedMerchant = null;
          //   selectedPackage = null;
          //   selectedServices.clear();
          //   selectedDate = null;
          //   selectedHour = null;
          // });
        } else if (state is CreateBookingError) {
          Navigator.pop(context);

          AppBottomSheets.showErrorBottomSheet(
            context,
            title: 'Gagal Melakukan Booking',
            message: state.message,
          );
        }
      },
      child: ContainerScreen(
        scrollable: false,
        title: "Layanan Cuci",
        bottomNavigationBar: _buildBottomButtons(),
        body: [
          Container(
            color: AppColors.light.background,
            height: 90.0.rheight,

            child: EasyStepper(
              internalPadding: 15,
              activeStep: currentStep,
              lineStyle: LineStyle(
                activeLineColor: AppColors.light.primary,
                defaultLineColor: AppColors.common.grey400,
                finishedLineColor: AppColors.light.success40,
                lineType: LineType.normal,
                lineThickness: 2,
              ),
              stepShape: StepShape.circle,
              stepBorderRadius: 0,
              borderThickness: 4,
              activeStepBorderColor: AppColors.light.primary,

              stepRadius: 18,
              unreachedStepBorderColor: AppColors.common.grey400,
              defaultStepBorderType: BorderType.normal,
              finishedStepBorderColor: AppColors.light.success40,

              finishedStepBackgroundColor: AppColors.light.success40,
              unreachedStepBackgroundColor: AppColors.common.grey400,
              activeStepBackgroundColor: AppColors.light.primary,
              activeStepIconColor: AppColors.light.primary,
              enableStepTapping: false,
              showLoadingAnimation: false,
              steps: [
                EasyStep(
                  customStep: AppText(
                    '1',
                    variant: TextVariant.body1,
                    weight: TextWeight.bold,
                    color: AppColors.common.white,
                  ),
                  customTitle: AppText(
                    'Data Kendaraan',
                    variant: TextVariant.body3,
                    weight: TextWeight.medium,
                  ),
                ),
                EasyStep(
                  customStep: AppText(
                    '2',
                    variant: TextVariant.body1,
                    weight: TextWeight.bold,
                    color: AppColors.common.white,
                  ),
                  customTitle: AppText(
                    'Pilih Merchant',
                    variant: TextVariant.body3,
                    weight: TextWeight.medium,
                  ),
                ),
                EasyStep(
                  customStep: AppText(
                    '3',
                    variant: TextVariant.body1,
                    weight: TextWeight.bold,
                    color: AppColors.common.white,
                  ),
                  customTitle: AppText(
                    'Pilih Paket',
                    variant: TextVariant.body3,
                    weight: TextWeight.medium,
                  ),
                ),
                EasyStep(
                  customStep: AppText(
                    '4',
                    variant: TextVariant.body1,
                    weight: TextWeight.bold,
                    color: AppColors.common.white,
                  ),
                  customTitle: AppText(
                    'Konfirmasi Booking',
                    variant: TextVariant.body3,
                    weight: TextWeight.medium,
                  ),
                ),
              ],
              onStepReached: (index) => setState(() => currentStep = index),
            ),
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                AppGap.height(20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildStepContent(currentStep),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    final bool isLastStep = currentStep == totalSteps - 1;

    // 🔹 Cek apakah step saat ini valid
    bool canProceed = false;

    switch (currentStep) {
      case 0:
        canProceed = platController.text.isNotEmpty;
        break;
      case 1:
        canProceed = selectedMerchant != null;
        break;
      case 2:
        canProceed =
            selectedPackage != null &&
            selectedDate != null &&
            selectedHour != null;
        break;
      default:
        canProceed = true;
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.light.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (currentStep > 0)
              Expanded(
                child: AppOutlineButton(
                  onPressed: previousStep,
                  text: "Kembali",
                ),
              ),
            if (currentStep > 0) const SizedBox(width: 8),

            Expanded(
              child: AppElevatedButton(
                text: isLastStep ? "Bayar" : "Selanjutnya",

                onPressed: canProceed
                    ? () {
                        isLastStep ? pay() : nextStep();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return StepOneWidget(
          colorController: colorController,
          platController: platController,
          vehicleType: vehicleType,
          selectedBrand: selectedBrand,
          selectedModel: selectedModel,
          onVehicleTypeChanged: (value) => setState(() => vehicleType = value),
          onBrandChanged: (value) => setState(() => selectedBrand = value),
          onModelChanged: (value) => setState(() => selectedModel = value),
        );

      case 1:
        return StepTwoWidget(
          initialCity: selectedCity,
          initialMerchant: selectedMerchant,
          onMerchantSelected: (merchant) {
            setState(() {
              selectedMerchant = merchant;
            });
            debugPrint(
              "✅ Merchant terpilih di ServicePage: ${merchant?.name ?? ""}",
            );
            resetStep3();
          },
          onCitySelected: (value) {
            setState(() {
              selectedCity = value;
            });
            resetStep3();
          },
        );
      case 2:
        return StepThreeWidget(
          selectedMerchant: selectedMerchant,
          initialPackage: selectedPackage,
          initialServices: selectedServices,
          initialDate: selectedDate,
          initialHour: selectedHour,
          onChanged: ({date, hour, package, services}) => _onStepThreeCompleted(
            date: date,
            hour: hour,
            package: package,
            selectedServices: services ?? [],
          ),
          selectedBrand: selectedBrand ?? '',
          selectedModel: selectedModel ?? '',
          vechicleType: vehicleType ?? '',
        );
      case 3:
        return StepFourWidget(
          onKasPlusChanged: (val) {
            setState(() {
              isKasPlusSelected = val;
            });
          },
          plateNumber: platController.text,
          vehicleType: vehicleType,
          brand: selectedBrand,
          model: selectedModel,
          selectedMerchant: selectedMerchant,
          selectedPackage: selectedPackage,
          selectedServices: selectedServices,
          selectedDate: selectedDate,
          selectedHour: selectedHour,
        );
      default:
        return const SizedBox();
    }
  }
}

class NavigatorButton extends StatelessWidget {
  final String title;
  final Widget screen;
  const NavigatorButton({super.key, required this.title, required this.screen});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      },
      child: Text(title),
    );
  }
}
