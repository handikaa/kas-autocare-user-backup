import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/share_method.dart';
import '../../../data/model/payment_data.dart';
import '../../../data/params/winpay_response_convert.dart';
import '../../../domain/entities/history/history_transaction_entity.dart';
import '../../cubit/detail_history_cubit.dart';
import '../../cubit/generate_qr_cubit.dart';
import '../../widget/card/product_transaction_card.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class DetailTransactionProduct extends StatefulWidget {
  const DetailTransactionProduct({super.key, required this.data});
  final PaymentData data;

  @override
  State<DetailTransactionProduct> createState() =>
      _DetailTransactionProductState();
}

class _DetailTransactionProductState extends State<DetailTransactionProduct> {
  WinpayResponseProduct? parsedData;
  bool isLoading = false;

  Future<void> saveQrGallery(
    WinpayResponseProduct parsedData, {
    required void Function(void Function()) dialogSetState,
  }) async {
    if (parsedData.qrData.qrUrl == null) {
      showAppSnackBar(
        context,
        message: "QR belum siap diunduh",
        type: SnackType.error,
      );
      return;
    }

    dialogSetState(() => isLoading = true);

    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        parsedData.qrData.qrUrl!,
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
      dialogSetState(() => isLoading = false);
    }
  }

  void showPaymentCodeDialog(BuildContext context, WinpayResponseProduct data) {
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
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      image: DecorationImage(
                        image: NetworkImage(data.qrData.qrUrl!),
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
                            await saveQrGallery(parsedData!, dialogSetState: s);
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

  @override
  Widget build(BuildContext context) {
    double maxH = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      backgroundColor: AppColors.light.primary,
      color: AppColors.common.white,
      onRefresh: () {
        return context.read<DetailHistoryCubit>().getDetailHistory(
          widget.data.id,
        ); // return Future
      },
      child: ContainerScreen(
        ontap: () {
          context.go('/dashboard');
        },
        title: "Detail Transaksi Produk",

        scrollable: true,
        bottomNavigationBar: _buildBottomButton(),
        body: [
          BlocBuilder<DetailHistoryCubit, DetailHistoryState>(
            builder: (context, state) {
              if (state is DetailHistoryLoading) {
                return Center(child: AppCircularLoading());
              }
              if (state is DetailHistoryError) {
                // context.pop();
                return Center(
                  child: AppText(
                    state.message,
                    variant: TextVariant.body2,
                    weight: TextWeight.medium,
                    maxLines: 10,
                    color: AppColors.light.error,
                  ),
                );
              }
              if (state is DetailHistoryLoaded) {
                final data = state.data;
                HistoryTransactionEntity historyTransaction =
                    data.historyTransactionEntity;

                if (historyTransaction.payment.data != "") {
                  final rawDataString = historyTransaction.payment.data;

                  parsedData = WinpayResponseProduct.fromRawJson(rawDataString);
                }
                final List<TransactionItemEntity>? products =
                    historyTransaction.transactionItems.isNotEmpty
                    ? historyTransaction.transactionItems
                          .where((e) => e.itemType == 'product')
                          .toList()
                    : null;

                return Column(
                  children: [
                    _buildInformationStatusTransaction(
                      data: historyTransaction,
                      payment: historyTransaction.payment,
                      onTap: () {
                        if (parsedData == null) {
                          showAppSnackBar(
                            context,
                            message: "Data belum siap",
                            type: SnackType.error,
                          );
                          return;
                        }
                        showPaymentCodeDialog(context, parsedData!);
                      },
                    ),

                    _buildProductCard(products),
                    _buildCardInformationOrder(
                      historyTransaction.shippingOrder,
                    ),
                    _buildCardRincianPriceOrder(
                      payMethod: historyTransaction.payment.method,
                      subTotalProduct: historyTransaction.totalPrice,
                      totalExpedition:
                          historyTransaction.shippingOrder.shippingCost,
                      totalPriceProduct: historyTransaction.finalPrice,
                    ),

                    AppGap.height(12),
                  ],
                );
              }

              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardInformationOrder(ShippingOrderEntity data) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15)),
        ],
      ),
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                "Informasi Pengiriman",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
            ],
          ),
          AppGap.height(12),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1.5),
            },
            children: [
              buildTableRow(
                'Kurir',
                "${data.serviceCode} ${data.courierService}",
              ),
              buildTableRow(
                'No resi',
                data.trackingNumber,
                canCopy: true,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: data.trackingNumber));

                  showAppSnackBar(
                    context,
                    message: "Nomor resi disalin",
                    type: SnackType.success,
                  );
                },
              ),
              buildTableRow('Nama Penerima', data.destinationName),
              buildTableRow('No HP', data.destinationPhone),

              buildTableRow('Alamat', data.destinationAddress),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardRincianPriceOrder({
    required String payMethod,
    required int subTotalProduct,
    required int totalExpedition,
    required int totalPriceProduct,
  }) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15)),
        ],
      ),
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                "Rincian Pembayaran",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
            ],
          ),
          AppGap.height(12),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1.5),
            },
            children: [
              buildTableRow(
                'Metode Pembayaran',
                payMethod,
                align: TextAlign.right,
              ),
              buildTableRow(
                'Subtotal Harga Produk',
                TextFormatter.formatRupiah(subTotalProduct),
                align: TextAlign.right,
              ),
              buildTableRow(
                'Ongkos Kirim',
                TextFormatter.formatRupiah(totalExpedition),
                align: TextAlign.right,
              ),
            ],
          ),
          AppGap.height(6),
          Divider(color: AppColors.common.black, thickness: 1),
          AppGap.height(6),
          Table(
            columnWidths: const {0: FlexColumnWidth(1)},
            children: [
              buildTableRow(
                'Total Belanja',
                TextFormatter.formatRupiah(totalPriceProduct),
                align: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(List<TransactionItemEntity>? products) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                "Detail Produk",
                variant: TextVariant.body2,
                weight: TextWeight.semiBold,
              ),
            ],
          ),
          AppGap.height(12),
          Column(
            children: List.generate(products!.length, (index) {
              final product = products[index];
              return ProductTransactionCard(
                img: product.image.first,
                title:
                    "${product.branchProductNews.name} - ${product.variantProduct.name} ${product.variantProductSize.size}",
                subtitle:
                    "${product.qty} x ${TextFormatter.formatRupiah(product.price)}",
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCardLacak() {
    return GestureDetector(
      onTap: () => context.push('/tracking-product', extra: widget.data.id),
      child: Container(
        padding: AppPadding.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.common.white,
        ),

        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 20,
              color: AppColors.light.primary,
            ),
            AppGap.width(6),
            AppText(
              "Lacak",
              variant: TextVariant.body2,
              weight: TextWeight.medium,
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: BlocBuilder<DetailHistoryCubit, DetailHistoryState>(
        builder: (context, state) {
          if (state is DetailHistoryLoaded) {
            HistoryTransactionEntity historyTransaction =
                state.data.historyTransactionEntity;
            if (historyTransaction.payment.data == '') {
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
                          context.read<DetailHistoryCubit>().getDetailHistory(
                            widget.data.id,
                          );
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
                        final bool isLoading = state is GenerateQrStateLoading;

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
            } else {
              return Container(
                color: AppColors.light.background,
                padding: AppPadding.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCardLacak(),
                    AppGap.height(12),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: AppElevatedButton(
                    //         text: "Download Invoice",
                    //         onPressed: () {
                    //           showAppSnackBar(
                    //             context,
                    //             message: "Berhasil Mendownload Invoice",
                    //             type: SnackType.success,
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  TableRow buildTableRow(
    String label,
    String value, {
    TextAlign? align,
    Color? labelColor,
    FontWeight? valueWeight,
    bool? canCopy = false,
    void Function()? onPressed,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AppText(
            label,
            align: TextAlign.left,
            variant: TextVariant.body3,
            weight: TextWeight.medium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: AppText(
                  maxLines: 5,
                  value,
                  align: align ?? TextAlign.left,
                  variant: TextVariant.body3,
                  weight: TextWeight.medium,
                ),
              ),
              if (canCopy == true)
                InkWell(onTap: onPressed, child: Icon(Icons.copy, size: 20)),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildInformationStatusTransaction({
  void Function()? onTap,

  required HistoryTransactionEntity data,
  required PaymentEntity payment,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.all(12),
    margin: EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.common.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.15)),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppText(
              ShareMethod.getStatusDetail(data.status),
              variant: TextVariant.body2,
              weight: TextWeight.semiBold,
            ),
            if (data.status == 'process_payment') ...[
              if (payment.data != '') ...[
                Spacer(),
                InkWell(
                  onTap: onTap,

                  child: AppText(
                    "Lihat Kode Bayar",
                    variant: TextVariant.body2,
                    weight: TextWeight.medium,
                    color: AppColors.light.mainBlue,
                  ),
                ),
              ],
            ],
          ],
        ),
        AppGap.height(6),
        Divider(color: AppColors.common.black, thickness: 1),

        AppGap.height(6),
        Row(
          children: [
            AppText(
              "Nomor Pesanan ${data.code}",
              variant: TextVariant.body3,
              weight: TextWeight.medium,
            ),
          ],
        ),
        AppGap.height(6),
        Row(
          children: [
            AppText(
              "Tanggal Pesanan",
              variant: TextVariant.body3,
              weight: TextWeight.medium,
            ),
            Spacer(),
            AppText(
              DateTimeFormatter.formatDateTime(data.createdAt),
              variant: TextVariant.body3,
              weight: TextWeight.medium,
            ),
          ],
        ),
      ],
    ),
  );
}
