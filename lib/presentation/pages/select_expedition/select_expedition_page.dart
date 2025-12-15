import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../data/params/shipping_params.dart';
import '../../../domain/entities/shipping_entity.dart';
import '../../cubit/shipping_subit.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class SelectExpeditionPage extends StatefulWidget {
  final ShippingParams params;
  const SelectExpeditionPage({super.key, required this.params});

  @override
  State<SelectExpeditionPage> createState() => _SelectExpeditionPageState();
}

class _SelectExpeditionPageState extends State<SelectExpeditionPage> {
  ShippingEntity? selectedExpedition;
  ServiceDetailEntity? selectedService;

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: "Opsi Pengiriman",
      scrollable: true,
      bottomNavigationBar: _buildBottomButton(),
      body: [
        AppText(
          align: TextAlign.left,
          "Pilih Ekspedisi",
          variant: TextVariant.body2,
          weight: TextWeight.bold,
        ),
        const SizedBox(height: 12),

        BlocBuilder<ShippingCubit, ShippingState>(
          builder: (context, state) {
            if (state is ShippingLoading) {
              return const Center(child: AppCircularLoading());
            } else if (state is ShippingError) {
              return Center(child: Text(state.message));
            } else if (state is ShippingLoaded) {
              final data = state.data;

              return Column(
                children: data.shipping.expand((shipping) {
                  return shipping.serviceDetail.map((service) {
                    final isSelected =
                        selectedExpedition?.courierCode ==
                            shipping.courierCode &&
                        selectedService?.serviceCode == service.serviceCode;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedExpedition = shipping;
                          selectedService = service;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: AppPadding.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColors.light.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    '${shipping.courierName} - ${service.service}',
                                    variant: TextVariant.body3,
                                    weight: TextWeight.bold,
                                  ),
                                  const SizedBox(height: 4),
                                  AppText(
                                    '${service.duration} | ${TextFormatter.formatRupiah(service.price)}',
                                    variant: TextVariant.body3,
                                    weight: TextWeight.medium,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppColors.light.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                }).toList(),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  SafeArea _buildBottomButton() {
    return SafeArea(
      child: Container(
        color: AppColors.light.background,
        padding: AppPadding.all(16),
        child: Row(
          children: [
            Expanded(
              child: AppElevatedButton(
                text: "Pilih",
                onPressed: selectedExpedition != null && selectedService != null
                    ? () {
                        Navigator.pop(context, selectedExpedition);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
