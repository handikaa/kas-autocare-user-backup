import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kas_autocare_user/data/params/get_hour_params.dart';
import 'package:kas_autocare_user/presentation/cubit/list_time_cubit.dart';
import 'package:kas_autocare_user/presentation/widget/icon/app_circular_loading.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../domain/entities/merchant_entity.dart';
import '../../../domain/entities/package_entity.dart';
import '../../../domain/entities/service_entity.dart';
import '../../cubit/package_cubit.dart';
import '../../cubit/service_cubit.dart';
import '../widget.dart';

class StepThreeWidget extends StatefulWidget {
  final MerchantEntity? selectedMerchant;
  final String selectedBrand;
  final String selectedModel;
  final String vechicleType;
  final PackageEntity? initialPackage;
  final List<ServiceEntity>? initialServices;
  final DateTime? initialDate;
  final String? initialHour;

  final Function({
    PackageEntity? package,
    List<ServiceEntity>? services,
    DateTime? date,
    String? hour,
  })?
  onChanged;

  const StepThreeWidget({
    super.key,
    this.selectedMerchant,
    this.initialPackage,
    this.initialServices,
    this.initialDate,
    this.initialHour,
    this.onChanged,
    required this.selectedBrand,
    required this.selectedModel,
    required this.vechicleType,
  });

  @override
  State<StepThreeWidget> createState() => _StepThreeWidgetState();
}

class _StepThreeWidgetState extends State<StepThreeWidget> {
  PackageEntity? selectedPackage;
  DateTime? selectedDate;
  String? selectedHour;

  List<PackageEntity> packageList = [];
  List<String> selectedServices = [];
  List<ServiceEntity> selectedServiceEntities = [];

  late List<Map<String, dynamic>> listHour;
  @override
  void initState() {
    super.initState();
    listHour = _generateDummyHours();
    selectedPackage = widget.initialPackage;
    selectedServiceEntities = widget.initialServices ?? [];
    selectedDate = widget.initialDate;
    selectedHour = widget.initialHour;

    selectedServices = selectedServiceEntities
        .map((srv) => "${srv.name} - ${TextFormatter.formatRupiah(srv.price)}")
        .toList();
  }

  List<Map<String, dynamic>> _generateDummyHours() {
    List<Map<String, dynamic>> hours = [];
    final random = Random();

    DateTime startTime = DateTime(2025, 1, 1, 7, 0);
    DateTime endTime = DateTime(2025, 1, 1, 22, 0);

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      final formatted = DateFormat('HH:mm').format(startTime);
      hours.add({'hour': formatted, 'available': random.nextBool()});
      startTime = startTime.add(const Duration(minutes: 30));
    }

    return hours;
  }

  void _showPackageBottomSheet(BuildContext context) {
    final cubit = context.read<PackageCubit>();
    final merchant = widget.selectedMerchant;

    if (merchant == null) {
      showAppSnackBar(
        context,
        message: "Harap pilih terlebih dahulu",
        type: SnackType.error,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicSelectionBottomSheet<PackageEntity>(
          searchHint: "Cari Paket",

          onFetchData: () async {
            final result = await cubit.fetchListPackage.execute(
              brnchId: merchant.id,
              bsnisId: merchant.bussinesId,
              brand: widget.selectedBrand,
              model: widget.selectedModel,
              vType: widget.vechicleType,
            );

            return result.fold((failure) {
              throw Exception(failure);
            }, (packages) => packages);
          },

          itemLabel: (pkg) {
            // Jika TIDAK ADA variant types → gunakan harga paket
            if (pkg.variantTypes.isEmpty ||
                pkg.variantTypes.first.variants.isEmpty) {
              return "${pkg.name} AllSize - ${TextFormatter.formatRupiah(pkg.price)}";
            }

            // Jika ADA variant types → ambil variant pertama
            VariantTypeEntity variantType = pkg.variantTypes.first;
            VariantEntity variant = variantType.variants.first;

            final labelVariant =
                (variant.size != null && variant.size!.isNotEmpty)
                ? variant.size
                : variant.facility;

            return "${pkg.name} $labelVariant - ${TextFormatter.formatRupiah(variant.price)}";
          },

          onItemSelected: (selected) {
            setState(() {
              selectedPackage = selected;
            });
            widget.onChanged?.call(
              package: selectedPackage,
              services: selectedServiceEntities,
              date: selectedDate,
              hour: selectedHour,
            );
          },
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    final merchant = widget.selectedMerchant;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BaseDatePickerBottomSheet(
          onApply: (selectedDateValue) {
            setState(() {
              selectedDate = selectedDateValue;
            });

            final formatted = DateFormat(
              "yyyy-MM-dd ",
              "id_ID",
            ).format(selectedDateValue);

            widget.onChanged?.call(
              package: selectedPackage,
              services: selectedServiceEntities,
              date: selectedDate,
              hour: selectedHour,
            );

            GetHourParams params = GetHourParams(
              bussinesId: merchant!.bussinesId,
              branchId: merchant.id,
              // merchant.id,
              date: formatted,
            );

            context.read<ListTimeCubit>().getListTIme(params: params);
          },
        );
      },
    );
  }

  void _showServiceMultiSelect(BuildContext context) {
    final serviceCubit = context.read<ServiceCubit>();
    final merchant = widget.selectedMerchant;

    if (merchant == null) {
      showAppSnackBar(
        context,
        message: "Harap pilih merchant terlebih dahulu",
        type: SnackType.error,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DynamicMultiSelectBottomSheet<ServiceEntity>(
          searchHint: "Cari Layanan",

          onFetchData: () async {
            await serviceCubit.getListService(
              branchId: merchant.id,
              businessId: merchant.bussinesId,
            );

            final state = serviceCubit.state;
            if (state is ServiceLoaded) {
              return state.services;
            } else if (state is ServiceError) {
              throw Exception(state.message);
            } else {
              return [];
            }
          },

          itemLabel: (service) =>
              "${service.name} - ${TextFormatter.formatRupiah(service.price)}",

          initiallySelected: selectedServices
              .map(
                (s) => selectedServiceEntities.firstWhere(
                  (srv) =>
                      "${srv.name} - ${TextFormatter.formatRupiah(srv.price)}" ==
                      s,
                  orElse: () => ServiceEntity(
                    id: 0,
                    name: s,
                    price: 0,
                    bussinesId: 0,
                    category: '',
                    vehicleType: '',
                    isWashingType: 0,
                    estimatedTime: 0,
                    branchId: 0,
                  ),
                ),
              )
              .toList(),

          onSelectionChanged: (selected) {
            setState(() {
              selectedServiceEntities = selected;

              selectedServices = selected
                  .map(
                    (srv) =>
                        "${srv.name} - ${TextFormatter.formatRupiah(srv.price)}",
                  )
                  .toList();
            });
            widget.onChanged?.call(
              package: selectedPackage,
              services: selectedServiceEntities,
              date: selectedDate,
              hour: selectedHour,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepBaseWidget(
      currentStep: 3,
      totalSteps: 4,

      children: [
        Row(
          children: [
            AppText(
              'Pilih Paket Pencucian',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(18),
        Row(
          children: [
            AppText(
              'Pilih Paket',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        GestureDetector(
          onTap: () => _showPackageBottomSheet(context),
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

                      selectedPackage != null
                          ? _buildSelectedPackageLabel(selectedPackage!)
                          : "Pilih paket cuci anda",
                      variant: TextVariant.body2,
                      color: selectedPackage != null
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

        Row(
          children: [
            AppText(
              'Pilih Layanan Tambahan',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        GestureDetector(
          onTap: () => _showServiceMultiSelect(context),
          child: Row(
            children: [
              Expanded(
                child: AppBox(
                  borderRadius: 8,
                  color: AppColors.common.white,
                  child: Padding(
                    padding: AppPadding.all(15),
                    child: selectedServices.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...selectedServices.map((e) {
                                final serviceData = selectedServiceEntities
                                    .firstWhere(
                                      (v) =>
                                          "${v.name} - ${TextFormatter.formatRupiah(v.price)}" ==
                                          e,
                                      orElse: () => ServiceEntity(
                                        id: 0,
                                        name: e,
                                        price: 0,
                                        bussinesId: 0,
                                        category: '',

                                        vehicleType: '',
                                        isWashingType: 0,
                                        estimatedTime: 0,
                                        branchId: 0,
                                      ),
                                    );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        "${serviceData.name} - ${serviceData.price}",
                                        variant: TextVariant.body2,
                                        color: AppColors.common.black,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          )
                        : AppText(
                            align: TextAlign.left,
                            'Pilih Layanan Cuci Anda',
                            variant: TextVariant.body2,
                            color: AppColors.common.grey400,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppGap.height(16),

        Row(
          children: [
            AppText(
              'Jadwal Booking',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(8),
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: AppBox(
            borderRadius: 8,
            color: AppColors.common.white,
            child: Padding(
              padding: AppPadding.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      align: TextAlign.left,
                      selectedDate != null
                          ? DateFormat(
                              "d MMMM yyyy",
                              "id_ID",
                            ).format(selectedDate!)
                          : 'Pilih Tanggal',
                      variant: TextVariant.body2,
                      weight: TextWeight.regular,
                      color: selectedDate != null
                          ? AppColors.common.black
                          : AppColors.common.grey400,
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_sharp,
                    color: AppColors.light.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        AppGap.height(16),
        if (selectedDate != null)
          BlocBuilder<ListTimeCubit, ListTimeState>(
            builder: (context, state) {
              if (state is ListTimeLoading) {
                return Center(child: AppCircularLoading());
              }

              if (state is ListTimeError) {
                return Center(
                  child: AppText(
                    state.message,
                    variant: TextVariant.body2,
                    weight: TextWeight.medium,
                  ),
                );
              }

              if (state is ListTimeLoaded) {
                final data = state.data;
                return Center(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 12,
                    children: data.map((item) {
                      final hour = item.time;
                      final available = item.available;
                      final isSelected = selectedHour == hour;

                      Color bgColor;
                      Color textColor;
                      BoxBorder? border;

                      if (!available) {
                        bgColor = Colors.grey.shade200;
                        textColor = Colors.grey;
                        border = Border.all(color: Colors.grey.shade300);
                      } else if (isSelected) {
                        bgColor = AppColors.light.primary;
                        textColor = Colors.white;
                        border = null;
                      } else {
                        bgColor = Colors.white;
                        textColor = Colors.grey;
                        border = Border.all(color: Colors.grey.shade300);
                      }

                      return GestureDetector(
                        onTap: available
                            ? () {
                                setState(() {
                                  selectedHour = hour;
                                });

                                widget.onChanged?.call(
                                  package: selectedPackage,
                                  services: selectedServiceEntities,
                                  date: selectedDate,
                                  hour: selectedHour,
                                );
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(30),
                            border: border,
                          ),
                          child: Text(
                            hour,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
      ],
    );
  }

  String _buildSelectedPackageLabel(PackageEntity pkg) {
    // CASE: Tidak punya variant types atau variant kosong
    if (pkg.variantTypes.isEmpty || pkg.variantTypes.first.variants.isEmpty) {
      return "${pkg.name} AllSize - ${TextFormatter.formatRupiah(pkg.price)}";
    }

    // CASE: Ada variant
    final variant = pkg.variantTypes.first.variants.first;

    final sizeOrFacility = (variant.size != null && variant.size!.isNotEmpty)
        ? variant.size
        : variant.facility;

    return "${pkg.name} $sizeOrFacility - ${TextFormatter.formatRupiah(variant.price)}";
  }
}
