import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/model/payment_data.dart';
import '../../cubit/generate_qr_cubit.dart';
import '../../cubit/notification/send_notification_cubit.dart';
import '../../cubit/payment_ws/payment_ws_cubit.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class PaymentInformationPage extends StatefulWidget {
  final PaymentData data;
  const PaymentInformationPage({super.key, required this.data});

  @override
  State<PaymentInformationPage> createState() => _PaymentInformationPageState();
}

class _PaymentInformationPageState extends State<PaymentInformationPage>
    with WidgetsBindingObserver {
  bool isLoading = false;

  late final PaymentWsCubit _wsCubit;
  String? qrUrl;

  void _fetchGenerateQr() {
    final cubit = context.read<GenerateQrCubit>();

    final extra = widget.data;

    if (widget.data.type == 'service') {
      cubit.getGenerateQrServiceCubit(
        id: extra.id,
        idMerchant: extra.subMerchant,
      );
    } else {
      cubit.getGenerateQrProductCubit(
        id: extra.id,
        idMerchant: extra.subMerchant,
      );
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
      } else {
        throw Exception("Gagal mengunduh QR (status: ${response.statusCode})");
      }
    } catch (e) {
      showAppSnackBar(context, message: e.toString(), type: SnackType.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _goDashboard() {
    // stop dulu biar event tidak nyangkut
    _wsCubit.stopListening();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/dashboard');
    });
  }

  void _sendNotifFcm({required String plate, required int userId}) {
    context.read<SendNotificationCubit>().sendNotification(
      title: "Booking Baru $plate",
      body: "Segera Konfirmasi Transaksi",
      message: "Segera Konfirmasi Transaksi",
      userId: userId,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _wsCubit = context.read<PaymentWsCubit>();

    _requestPermission();
    _fetchGenerateQr();

    final ref = widget.data.code?.trim() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _wsCubit.startListening(ref);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // jangan emit idle saat dispose (seperti yang sudah kita rapikan)
    _wsCubit.stopListening(emitIdle: false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.resumed) {
      // 1) pastikan WS masih listen (reconnect kalau perlu)
      _wsCubit.ensureListening(widget.data.code ?? "");

      // 2) fallback cek status via API (jika payment terjadi saat background)
      // _wsCubit.checkStatusOnce(widget.data.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goDashboard();
      },
      child: ContainerScreen(
        ontap: () => context.go('/dashboard'),
        scrollable: true,
        title: "Info Pembayaraan",
        bottomNavigationBar: BlocBuilder<GenerateQrCubit, GenerateQrState>(
          builder: (context, state) {
            if (state is GenerateQrStateSuccess) {
              final qrData = state.data;
              String? qrUrl = qrData.qrUrl != ''
                  ? qrData.qrUrl
                  : qrData.qrEntity.url;

              return _buildButtonBottomNav(context, qrUrl);
            }
            return SizedBox.shrink();
          },
        ),
        body: [
          BlocListener<PaymentWsCubit, PaymentWsState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, wsState) {
              if (wsState.status == PaymentWsStatus.paid) {
                context.read<PaymentWsCubit>().stopListening(
                  emitIdle: false,
                ); // stop tanpa emit

                // context.go('/dashboard'); atau tampilkan dialog/snackbar
                showAppSnackBar(
                  context,
                  message: "Pembayaran Berhasil",
                  type: SnackType.success,
                );
                context.go('/detail-booking-transaction', extra: widget.data);

                // _sendNotifFcm(
                //   plate: widget.data.plate ?? "-",
                //   userId: widget.data.userId ?? 0,
                // );
              }

              if (wsState.status == PaymentWsStatus.error) {
                // contoh aksi ketika error
                showAppSnackBar(
                  context,
                  message: wsState.error ?? "Error Pembayaran",
                  type: SnackType.error,
                );
              }
            },
            child: Container(
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
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  SafeArea _buildButtonBottomNav(BuildContext context, String? qrUrl) {
    return SafeArea(
      child: Container(
        padding: AppPadding.all(16),
        color: AppColors.light.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (qrUrl != null)
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
                          extra: widget.data,
                        );
                      } else {
                        context.go(
                          '/detail-transaction-product',
                          extra: widget.data,
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
