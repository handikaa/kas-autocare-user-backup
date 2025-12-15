import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/presentation/widget/icon/app_circular_loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/model/payment_data.dart';
import '../../cubit/generate_qr_cubit.dart';
import '../../widget/widget.dart';

class PaymentInformationPage extends StatefulWidget {
  final PaymentData data;
  const PaymentInformationPage({super.key, required this.data});

  @override
  State<PaymentInformationPage> createState() => _PaymentInformationPageState();
}

class _PaymentInformationPageState extends State<PaymentInformationPage> {
  bool isLoading = false;

  String? qrUrl;

  @override
  void initState() {
    super.initState();
    _requestPermission();

    _fetchGenerateQr();
  }

  void _fetchGenerateQr() {
    final cubit = context.read<GenerateQrCubit>();

    final int id = widget.data.id;

    if (widget.data.type == 'service') {
      cubit.getGenerateQrServiceCubit(id);
    } else {
      cubit.getGenerateQrProductCubit(id);
    }
  }

  Future<void> _requestPermission() async {
    bool isGranted = false;

    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt < 33) {
        isGranted = await Permission.storage.request().isGranted;
      } else {
        isGranted = await Permission.photos.request().isGranted;
      }
    } else if (Platform.isIOS) {
      isGranted = await Permission.photosAddOnly.request().isGranted;
    }

    debugPrint('📱 Permission Request Result: $isGranted');
  }

  Future<void> _saveQrGallery() async {
    if (qrUrl == null) {
      showAppSnackBar(
        context,
        message: "QR belum siap diunduh",
        type: SnackType.error,
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final dio = Dio();

      final response = await dio.get<List<int>>(
        qrUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Uint8List bytes = Uint8List.fromList(response.data!);
        final String fileName =
            "qris_${DateTime.now().millisecondsSinceEpoch}.jpg";

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
          return;
        }

        showAppSnackBar(
          context,
          message: "Berhasil mendownload QRIS, lihat di galeri Anda",
          type: SnackType.success,
        );

        // await Future.delayed(const Duration(seconds: 1));
        // if (mounted) context.push('/detail-transaction');
      } else {
        throw Exception("Gagal mengunduh QR (status: ${response.statusCode})");
      }
    } catch (e) {
      showAppSnackBar(context, message: e.toString(), type: SnackType.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // void _startCountdown() {
  //   _remainingTime = const Duration(hours: 24);

  //   _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (_remainingTime.inSeconds <= 0) {
  //       timer.cancel();
  //     } else {
  //       setState(() {
  //         _remainingTime = _remainingTime - const Duration(seconds: 1);
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    // _countdownTimer?.cancel();
    super.dispose();
  }

  // String _formatDuration(Duration d) {
  //   final hours = d.inHours.toString().padLeft(2, '0');
  //   final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
  //   final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
  //   return '$hours:$minutes:$seconds';
  // }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.go('/dashboard');
      },
      child: ContainerScreen(
        ontap: () => context.go('/dashboard'),
        scrollable: true,
        title: "Info Pembayaraan",
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: AppPadding.all(16),
            color: AppColors.light.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppOutlineButton(
                        text: isLoading ? "Mengunduh..." : "Download Qris",
                        onPressed: isLoading
                            ? null
                            : () {
                                _saveQrGallery();
                              },
                      ),
                    ),
                  ],
                ),
                AppGap.height(12),
                Row(
                  children: [
                    Expanded(
                      child: AppElevatedButton(
                        text: "Lihat Status Pembayaran",
                        onPressed: () {
                          if (widget.data.type == 'service') {
                            context.go(
                              '/detail-booking-transaction',
                              extra: widget.data.id,
                            );
                          } else {
                            context.go(
                              '/detail-transaction-product',
                              extra: widget.data.id,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: AppColors.common.white),
            padding: AppPadding.all(12),
            child: BlocBuilder<GenerateQrCubit, GenerateQrState>(
              builder: (context, state) {
                if (state is GenerateQrStateLoading) {
                  return const Center(child: AppCircularLoading());
                }

                if (state is GenerateQrStateError) {
                  return Center(
                    child: Text(
                      "Gagal memuat QR: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (state is GenerateQrStateSuccess) {
                  final qrData = state.data;

                  qrUrl = qrData.qrUrl != ''
                      ? qrData.qrUrl
                      : qrData.qrEntity.url;

                  return Column(
                    children: [
                      AppText(
                        'Total Pembayaran',
                        variant: TextVariant.heading7,
                        weight: TextWeight.medium,
                      ),
                      AppGap.height(12),
                      AppText(
                        TextFormatter.formatRupiah(
                          qrData.totalTransactionPrice,
                        ),
                        variant: TextVariant.heading7,
                        weight: TextWeight.semiBold,
                        color: AppColors.light.primary,
                      ),
                      AppGap.height(48),
                      AppText(
                        'KAS Autocare Bogor',
                        variant: TextVariant.heading7,
                        weight: TextWeight.medium,
                        color: AppColors.common.black,
                      ),

                      AppGap.height(48),
                      Container(
                        height: maxH * 0.6,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                          image: DecorationImage(
                            image: NetworkImage(qrUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // AppGap.height(48),
                      // Row(
                      //   children: const [
                      //     Icon(Icons.receipt_long, color: Colors.teal),
                      //     SizedBox(width: 8),
                      //     Text(
                      //       'Rincian Pembayaran',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 16,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // AppGap.height(12),
                      // Table(
                      //   columnWidths: const {
                      //     0: FlexColumnWidth(1.5),
                      //     1: FlexColumnWidth(2),
                      //   },
                      //   children: [
                      //     buildTableRow('Sub Tiket', 'Rp1.300.100'),
                      //     buildTableRow('Bagasi 20kg/Pax', 'Rp450.000'),
                      //     buildTableRow('Asuransi Penerbangan/Pax', 'Rp181.000'),
                      //     buildTableRow(
                      //       'Penjadwalan Ulang Penerbangan/Pax',
                      //       'Rp181.000',
                      //     ),
                      //     buildTableRow('Pengembalian Dana/Pax', 'Rp517.000'),
                      //   ],
                      // ),
                      // AppGap.height(12),
                      // DashedDivider(
                      //   color: AppColors.common.black,
                      //   height: 1,
                      //   dashWidth: 12,
                      //   dashSpace: 6,
                      // ),
                      // AppGap.height(12),
                      // Table(
                      //   columnWidths: const {
                      //     0: FlexColumnWidth(1.5),
                      //     1: FlexColumnWidth(2),
                      //   },
                      //   children: [
                      //     buildTableRow('Total Pembayaran', 'Rp2.551.100'),
                      //   ],
                      // ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
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
            align: TextAlign.right,
            variant: TextVariant.body2,
            weight: TextWeight.medium,
          ),
        ),
      ],
    );
  }
}
