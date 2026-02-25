import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kas_autocare_user/core/config/theme/app_text_style.dart';
import 'package:kas_autocare_user/domain/entities/history/history_transaction_entity.dart';
import 'package:kas_autocare_user/presentation/cubit/detail_history_cubit.dart';
import 'package:kas_autocare_user/presentation/widget/widget.dart';
import 'package:universal_stepper/universal_stepper.dart';

import '../../../core/config/theme/app_colors.dart';

class TrackingProductPage extends StatefulWidget {
  const TrackingProductPage({super.key, required this.trxId});

  final int trxId;

  @override
  State<TrackingProductPage> createState() => _TrackingProductPageState();
}

class _TrackingProductPageState extends State<TrackingProductPage> {
  int currentStep = 5;

  StepperBadgePosition badgePosition =
      StepperBadgePosition.center; // Set the desired badgePosition

  bool isInverted = false;

  List<StepperData> trackOrderPosition = [
    StepperData(
      title: "Paket telah diambil oleh kurir (Hero)",
      date: "Sabtu, 23 Agustus 2025 – 15:59 WIB",
    ),
    StepperData(
      title: "Paket sedang dalam proses pengiriman",
      date: "Sabtu, 23 Agustus 2025 – 15:59 WIB",
    ),
    StepperData(
      title: "Pesanan berada di gudang tujuan",
      date: "Senin, 25 Agustus 2025 - 08:10 WIB",
    ),
    StepperData(
      title: "Kurir sedang dalam perjalanan menuju lokasi pengantaran",
      date: "Senin, 25 Agustus 2025 - 08:55 WIB",
    ),
    StepperData(
      title: "Kurir telah sampai di lokasi tujuan",
      date: "Senin, 25 Agustus 2025 - 10:08 WIB",
    ),
    StepperData(
      title: "Pesanan Anda telah tiba dan diterima oleh Sandi, YBS",
      date: "Senin, 25 Agustus 2025 - 10:08 WIB",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      title: "Lacak Produk",
      scrollable: true,
      body: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.common.white,

            borderRadius: BorderRadius.circular(12),
          ),
          padding: AppPadding.all(12),
          child: Column(
            children: [
              BlocBuilder<DetailHistoryCubit, DetailHistoryState>(
                builder: (context, state) {
                  if (state is DetailHistoryLoaded) {
                    HistoryTransactionEntity historyTransaction =
                        state.data.historyTransactionEntity;
                    return _buildAddressCustomer(historyTransaction);
                  }
                  return SizedBox.shrink();
                },
              ),
              AppGap.height(12),

              // _buildStatusOrder(),
              SizedBox(
                child: UniversalStepper(
                  inverted: isInverted,
                  stepperDirection: Axis.vertical,
                  elementCount: trackOrderPosition.length,
                  badgePosition: badgePosition,

                  elementBuilder: (context, index) {
                    final reversedIndex = trackOrderPosition.length - 1 - index;
                    final data = trackOrderPosition[reversedIndex];

                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (data.title.isNotEmpty)
                              Text(data.title, textAlign: TextAlign.start),
                            if (data.kurir.isNotEmpty)
                              Text(
                                "Kurir : ${data.kurir}",
                                textAlign: TextAlign.start,
                              ),
                          ],
                        ),
                      ),
                    );
                  },

                  badgeBuilder: (context, index) {
                    final reversedIndex = trackOrderPosition.length - 1 - index;
                    return Container(
                      width: 30,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: reversedIndex <= currentStep
                            ? AppColors.light.primary
                            : Colors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: const FittedBox(
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    );
                  },

                  pathBuilder: (context, index) {
                    final reversedIndex = trackOrderPosition.length - 1 - index;
                    return Container(
                      color: reversedIndex == trackOrderPosition.length - 1
                          ? Colors.transparent
                          : (reversedIndex <= currentStep
                                ? AppColors.light.primary
                                : Colors.grey),
                      width: 4,
                    );
                  },

                  subPathBuilder: (context, index) {
                    final reversedIndex = trackOrderPosition.length - 1 - index;
                    return Container(
                      color: reversedIndex == 0
                          ? Colors.transparent
                          : (reversedIndex <= currentStep
                                ? AppColors.light.primary
                                : Colors.grey),
                      width: 4,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildStatusOrder(HistoryTransactionEntity data) {
    return Column(
      children: [
        Row(
          children: [
            AppText(
              'Status',
              variant: TextVariant.body2,
              weight: TextWeight.bold,
            ),
          ],
        ),
        AppGap.height(6),
        Row(
          children: [
            AppText(
              'Dikemas',
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressCustomer(HistoryTransactionEntity data) {
    return Column(
      children: [
        Row(
          children: [
            AppText(
              'Alamat Penerima',
              variant: TextVariant.body2,
              weight: TextWeight.bold,
            ),
          ],
        ),

        AppGap.height(6),
        Row(
          children: [
            AppText(
              data.shippingOrder.destinationName,
              variant: TextVariant.body3,
              weight: TextWeight.bold,
            ),
          ],
        ),
        AppGap.height(6),
        Row(
          children: [
            AppText(
              data.shippingOrder.destinationPhone,
              variant: TextVariant.body3,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(6),
        Row(
          children: [
            Expanded(
              child: AppText(
                "${data.shippingOrder.destinationProvinceName}, ${data.shippingOrder.destinationCityName}, ${data.shippingOrder.destinationCityName}, ${data.shippingOrder.destinationAddress}",
                maxLines: 6,
                align: TextAlign.left,
                variant: TextVariant.body3,
                weight: TextWeight.medium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StepperData {
  final String date;
  final String title;
  final String kurir;

  StepperData({required this.title, required this.date, this.kurir = "Paxel"});
}
