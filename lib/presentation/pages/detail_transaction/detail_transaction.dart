import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/data/model/payment_data.dart';
import 'package:kas_autocare_user/domain/entities/package_entity.dart';
import 'package:kas_autocare_user/presentation/cubit/generate_qr_cubit.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/assets/app_images.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/share_method.dart';
import '../../../data/params/winpay_response_convert.dart';
import '../../../domain/entities/history_transaction_entity.dart';
import '../../../domain/entities/service_entity.dart';
import '../../cubit/detail_history_cubit.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class DetailBookingTransactionPage extends StatefulWidget {
  final PaymentData data;
  const DetailBookingTransactionPage({super.key, required this.data});

  @override
  State<DetailBookingTransactionPage> createState() =>
      _DetailBookingTransactionPageState();
}

class _DetailBookingTransactionPageState
    extends State<DetailBookingTransactionPage> {
  bool isLoading = false;
  WinpayResponse? parsedData;

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;

    void generateQr() async {
      try {
        setState(() {
          isLoading = true;
        });
        context.read<GenerateQrCubit>().getGenerateQrServiceCubit(
          id: widget.data.subMerchant,
          idMerchant: widget.data.subMerchant,
        );
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    Future<void> saveQrGallery(
      WinpayResponse parsedData, {
      required void Function(void Function()) dialogSetState,
    }) async {
      if (parsedData.qrUrl == null) {
        showAppSnackBar(
          context,
          message: "QR belum siap diunduh",
          type: SnackType.error,
        );
        return;
      }

      // 🔥 update loading di dialog
      dialogSetState(() => isLoading = true);

      try {
        final dio = Dio();
        final response = await dio.get<List<int>>(
          parsedData.qrUrl!,
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.statusCode == 200 && response.data != null) {
          final bytes = Uint8List.fromList(response.data!);
          final fileName = "qris_${DateTime.now().millisecondsSinceEpoch}.jpg";

          final result = await SaverGallery.saveImage(
            bytes,
            fileName: fileName,
            skipIfExists: false,
          );

          if (!result.isSuccess) {
            showAppSnackBar(
              context,
              message: "Gagal menyimpan QR ke galeri",
              type: SnackType.error,
            );
          } else {
            showAppSnackBar(
              context,
              message: "Berhasil mendownload QRIS, lihat di galeri Anda",
              type: SnackType.success,
            );
          }
        }
      } catch (e) {
        showAppSnackBar(context, message: e.toString(), type: SnackType.error);
      } finally {
        dialogSetState(() => isLoading = false); // 🔥 tutup loading
      }
    }

    void showPaymentCodeDialog(BuildContext context, WinpayResponse data) {
      showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(
            builder: (context, s) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: AppColors.common.white,

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.partnerReferenceNo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.common.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      height: maxH * 0.5,
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        image: DecorationImage(
                          image: NetworkImage(data.qrUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppOutlineButton(
                      text: isLoading ? "Mengunduh" : "Download QRIS",
                      onPressed: isLoading
                          ? null
                          : () async {
                              await saveQrGallery(
                                parsedData!,
                                dialogSetState: s,
                              );
                            },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return RefreshIndicator(
      backgroundColor: AppColors.light.primary,
      color: AppColors.common.white,
      onRefresh: () {
        return context.read<DetailHistoryCubit>().getDetailHistory(
          widget.data.id,
        ); // return Future
      },
      child: ContainerScreen(
        bottomNavigationBar:
            BlocBuilder<DetailHistoryCubit, DetailHistoryState>(
              builder: (context, state) {
                if (state is DetailHistoryLoaded) {
                  if (state.data.status == 'pending') {
                    return Container(
                      color: AppColors.light.background,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: BlocConsumer<GenerateQrCubit, GenerateQrState>(
                            listenWhen: (prev, curr) =>
                                curr is GenerateQrStateSuccess ||
                                curr is GenerateQrStateError,
                            listener: (context, state) {
                              if (state is GenerateQrStateSuccess) {
                                context
                                    .read<DetailHistoryCubit>()
                                    .getDetailHistory(widget.data.id);
                              }

                              if (state is GenerateQrStateError) {
                                showAppSnackBar(
                                  context,
                                  message: state.message,
                                  type: SnackType.error,
                                );
                              }
                            },
                            builder: (context, state) {
                              final bool isLoading =
                                  state is GenerateQrStateLoading;

                              return Row(
                                children: [
                                  Expanded(
                                    child: AppElevatedButton(
                                      text: isLoading
                                          ? "Loading..."
                                          : "Buat Kode Bayar",
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              context
                                                  .read<GenerateQrCubit>()
                                                  .getGenerateQrServiceCubit(
                                                    id: widget.data.id,
                                                    idMerchant:
                                                        widget.data.subMerchant,
                                                  );
                                            },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                }
                return SizedBox.shrink();
              },
            ),
        ontap: () {
          context.go('/dashboard');
        },
        scrollable: true,
        title: "Detail Transaksi",
        // bottomNavigationBar: SafeArea(
        //   child: Container(
        //     padding: AppPadding.all(16),
        //     color: AppColors.light.background,
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: AppElevatedButton(
        //             text: isLoading
        //                 ? "Menyimpan data"
        //                 : "Kembali ke halaman utama",
        //             onPressed: isLoading ? null : _backtoHome,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: [
          BlocBuilder<DetailHistoryCubit, DetailHistoryState>(
            builder: (context, state) {
              if (state is DetailHistoryLoading) {
                return Center(child: AppCircularLoading());
              }
              if (state is DetailHistoryError) {
                return Center(
                  child: AppText(
                    state.message,
                    variant: TextVariant.body2,
                    weight: TextWeight.medium,
                    color: AppColors.light.error,
                  ),
                );
              }

              if (state is DetailHistoryLoaded) {
                final data = state.data;

                // List<TransactionItemEntity> trxItem = data.transactionItems;
                // PackageEntity package =
                if (data.payment.data != "") {
                  final rawDataString = data.payment.data;

                  parsedData = WinpayResponse.fromRawJson(rawDataString);
                }

                final TransactionItemEntity? package = data.transactionItems
                    .where((e) => e.itemType == 'package')
                    .firstOrNull;

                final List<ServiceEntity>? services =
                    data.transactionItems.isNotEmpty
                    ? data.transactionItems
                          .where((e) => e.itemType == 'service')
                          .map((e) => e.serviceEntity)
                          .toList()
                    : null;

                bool isKasPlusSelected = data.isKasPlus == 1;

                PackageEntity packageEntity = PackageEntity(
                  id: 0,
                  name:
                      "${package?.packageNew.name ?? ""} ${package?.packageVariantNew.size ?? ""}",
                  vehicleType: package?.packageNew.vehicleType ?? '-',
                  modelId: 0,
                  isWashingType: 0,
                  estimatedTime: 0,
                  branchId: package?.packageNew.branchId ?? 0,
                  bussinesId: package?.packageNew.bussinesId ?? 0,
                  description: "",
                  price: package?.packageVariantNew.price ?? 0,
                  category: "",
                  matchedVehicleModel: MatchedVehicleModelEntity(
                    id: 0,
                    name: '',
                    brand: '',
                    size: '',
                    bodyType: '',
                    vehicleType: '',
                  ),
                  variantTypes: [],
                );

                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.common.white,

                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: AppPadding.all(12),
                  child: Column(
                    children: [
                      AppGap.height(12),
                      Image(image: AssetImage(AppImages.logoTeks), width: 140),
                      _buildStatusIcon(data.status),
                      AppGap.height(12),
                      AppText(
                        maxLines: 3,
                        ShareMethod.getStatusDetail(data.status),
                        variant: TextVariant.body2,
                        weight: TextWeight.semiBold,
                      ),
                      AppGap.height(8),
                      if (data.status == 'payment_success') ...[
                        AppText(
                          maxLines: 3,
                          'Menunggu Konfirmasi Carwash',
                          variant: TextVariant.body2,
                          weight: TextWeight.semiBold,
                        ),
                      ],
                      AppGap.height(8),
                      AppText(
                        DateTimeFormatter.formatDateTime(data.createdAt),
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                      ),
                      if (data.status == 'process_payment') ...[
                        if (data.payment.data != "") ...[
                          AppGap.height(12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: AppOutlineButton(
                              height: 35,
                              text: "Lihat Kode Bayar",
                              onPressed: () {
                                showPaymentCodeDialog(context, parsedData!);
                              },
                            ),
                          ),
                        ],
                      ],

                      AppGap.height(24),
                      Row(
                        children: [
                          AppText(
                            "Detail Data Kendaraan",
                            variant: TextVariant.body2,
                            weight: TextWeight.bold,
                          ),
                        ],
                      ),
                      AppGap.height(8),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.5),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          buildTableRow('Nama Pemilik', data.ownerName),
                          buildTableRow('Flat Nomor', data.licensePlate),
                          buildTableRow(
                            'Tipe Kendaraan',
                            ShareMethod.getStatusVehicleType(data.vehicleType),
                          ),
                          buildTableRow('Brand', data.brand),
                          buildTableRow('Model', data.model),
                          buildTableRow('Warna', data.color),
                        ],
                      ),
                      AppGap.height(12),
                      DashedDivider(
                        color: AppColors.common.black,
                        height: 1,
                        dashWidth: 12,
                        dashSpace: 6,
                      ),
                      AppGap.height(12),
                      Row(
                        children: [
                          AppText(
                            "Detail Booking",
                            variant: TextVariant.body2,
                            weight: TextWeight.bold,
                          ),
                        ],
                      ),
                      AppGap.height(8),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.5),
                          1: FlexColumnWidth(2),
                        },
                        children: [
                          buildTableRow(
                            'Jadwal Booking',
                            "${DateTimeFormatter.formatDateOnly(data.scheduleDate)}, ${data.scheduleTime}",
                          ),
                          if (data.isKasPlus == 1)
                            buildTableRow('Prioritas', 'KAS PLUS Prioritas'),
                          buildTableRow('Carwash', data.branch.storeName),
                          buildTableRow(
                            'Lokasi Carwash',
                            "${data.branch.address} ${data.branch.district} ${data.branch.city}",
                          ),
                        ],
                      ),
                      AppGap.height(12),
                      DashedDivider(
                        color: AppColors.common.black,
                        height: 1,
                        dashWidth: 12,
                        dashSpace: 6,
                      ),
                      AppGap.height(12),

                      RincianPesananCard(
                        paketUtama: packageEntity,

                        hargaUtama: package?.packageVariantNew.price ?? 0,
                        layananTambahan: services ?? [],
                        totalPembayaran: _calculateTotal(
                          basePrice: package?.packageVariantNew.price ?? 0,
                          data: data,
                          isKasPlusSelected: isKasPlusSelected,
                        ),
                        isKasPlusSelected: isKasPlusSelected,
                        isCard: false,
                      ),
                      AppGap.height(68),
                      AppText(
                        "KAS autocare | Copyright 2025 | All right reserved.",
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                      ),
                    ],
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Gagal mengambil data",
                    variant: TextVariant.body2,
                    weight: TextWeight.semiBold,
                    color: AppColors.light.error,
                  ),
                  AppGap.height(18),
                  AppElevatedButton(text: "Coba Lagi"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  int _calculateTotal({
    required int basePrice,
    required HistoryTransactionEntity data,
    required bool isKasPlusSelected,
  }) {
    final List<ServiceEntity>? services = data.transactionItems.isNotEmpty
        ? data.transactionItems
              .where((e) => e.itemType == 'service')
              .map((e) => e.serviceEntity)
              .toList()
        : null;

    final additional =
        services?.fold<int>(0, (sum, service) => sum + service.price) ?? 0;

    final kasPlusFee = isKasPlusSelected ? 10000 : 0;

    return basePrice + additional + kasPlusFee;
  }

  Widget _buildStatusIcon(String status) {
    String image;
    switch (status) {
      case "process_payment":
        image = AppIcons.wallet;
        break;

      case "payment_success":
        image = AppIcons.wallet;
        break;

      case "cancelled":
        image = AppIcons.failedIcon;
        break;

      case "completed":
        image = AppIcons.successIcon;
        break;

      case "in_progress":
        image = AppIcons.warningIcon;
        break;

      case "accepted":
        image = AppIcons.wallet;
        break;

      case "rejected":
        image = AppIcons.failedIcon;
        break;

      case "pending":
        image = AppIcons.warningIcon;
        break;
      case "expired":
        image = AppIcons.failedIcon;
        break;
      default:
        image = AppIcons.warningIcon;
    }

    return Image(image: AssetImage(image), width: 140);
  }

  TableRow buildTableRow(
    String label,
    String value, {

    Color? labelColor,
    FontWeight? valueWeight,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(
            label,
            align: TextAlign.left,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(
            value,
            maxLines: 4,
            align: TextAlign.right,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
      ],
    );
  }
}

// PackageEntity dataDummy = PackageEntity(
//   id: 12,
//   name: "Cuci non hidrolik",
//   vehicleType: 'car',
//   isWashingType: 12,
//   estimatedTime: 12,
//   branchId: 12,
//   bussinesId: 12,
//   description: "Desc",
//   price: 123123,
//   category: "category", modelId: null, matchedVehicleModel: null, variantTypes: [],
// );
