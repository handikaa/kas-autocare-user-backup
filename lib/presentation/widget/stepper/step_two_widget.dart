import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/assets/app_images.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../data/model/params_location.dart';
import '../../../domain/entities/merchant_entity.dart';
import '../../cubit/merchant_nearby_cubit.dart';
import '../icon/app_circular_loading.dart';
import '../widget.dart';

class StepTwoWidget extends StatefulWidget {
  final Function(MerchantEntity? merchant)? onMerchantSelected;

  final ValueChanged<String?>? onCitySelected;
  final String? initialCity;
  final MerchantEntity? initialMerchant;

  const StepTwoWidget({
    super.key,
    this.onMerchantSelected,
    this.initialCity,
    this.initialMerchant,
    this.onCitySelected,
  });

  @override
  State<StepTwoWidget> createState() => _StepTwoWidgetState();
}

class _StepTwoWidgetState extends State<StepTwoWidget> {
  int? selectedMerchantId;
  String? selectedCity;

  MerchantEntity? selectedMerchant;

  String _getLocationText({String? city, double? lat, double? long}) {
    final hasLatLong = lat != null && long != null;
    final hasCity = city != null && city.isNotEmpty;

    if (hasLatLong && hasCity) {
      return 'Di sekitar anda - $city';
    } else if (hasLatLong && !hasCity) {
      return 'Di sekitar anda';
    } else if (hasCity) {
      return city;
    } else {
      return 'Cari Lokasi';
    }
  }

  @override
  void initState() {
    super.initState();

    selectedCity = widget.initialCity;

    if (widget.initialMerchant != null) {
      selectedMerchant = widget.initialMerchant;
      selectedMerchantId = widget.initialMerchant!.id;
    } else {
      selectedMerchantId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchantNearbyCubit = context.read<MerchantNearbyCubit>();

    return StepBaseWidget(
      currentStep: 2,
      totalSteps: 4,
      children: [
        GestureDetector(
          onTap: () async {
            final result = await context.push<ParamsLocation>(
              '/find-location',
              extra: 'city',
            );

            if (result != null) {
              merchantNearbyCubit.getNearbyMerchants(result);

              setState(() {
                selectedCity = result.city;

                selectedMerchantId = null;
                selectedMerchant = null;
              });

              widget.onMerchantSelected?.call(null);

              widget.onCitySelected?.call(selectedCity);
            }
          },
          child: AppBox(
            color: AppColors.common.white,
            borderRadius: 8,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      align: TextAlign.left,
                      "${selectedCity ?? "Cari lokasi"} ",
                      variant: TextVariant.body2,
                      weight: TextWeight.medium,
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.common.black,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),

        AppGap.height(16),

        BlocBuilder<MerchantNearbyCubit, MerchantNearbyState>(
          builder: (context, state) {
            if (state is MerchantNearbyLoading) {
              return const Center(child: AppCircularLoading());
            } else if (state is MerchantNearbyError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is MerchantNearbyLoaded) {
              final merchants = state.merchants;

              if (merchants.isEmpty) {
                return const Center(
                  child: Text("Belum ada merchant di lokasi ini."),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Merchant di ${selectedCity ?? "Sekitar Anda"}',

                    variant: TextVariant.body2,
                    weight: TextWeight.regular,
                  ),
                  AppGap.height(8),
                  Column(
                    children: List.generate(merchants.length, (index) {
                      final merchant = merchants[index];
                      final isSelected = selectedMerchantId == merchant.id;
                      final isOpen = merchant.storeStatus.isOpen;
                      final closeMessage = merchant.storeStatus.message;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: isOpen
                              ? () {
                                  setState(() {
                                    selectedMerchantId = merchant.id;
                                    selectedMerchant = merchant;
                                  });

                                  widget.onMerchantSelected?.call(merchant);
                                }
                              : null,
                          child: MerchantCard(
                            text: merchant.storeName,
                            type: merchant.address,
                            rating: 0.0,
                            closeMessage: closeMessage,
                            isOpen: isOpen,
                            isSelected: isSelected,
                            img: AppImages.path(
                              'carwash',
                              format: ImageFormater.jpg,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
