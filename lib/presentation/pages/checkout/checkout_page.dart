import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_dialog.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/dummy/dummy_payment_method.dart';
import '../../../data/model/payment_data.dart';
import '../../../data/model/payment_method.dart';
import '../../../data/params/checkout_payload.dart';
import '../../../data/params/shipping_params.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/chart_entity.dart';
import '../../../domain/entities/shipping_entity.dart';
import '../../cubit/checkout_cubit.dart';
import '../../widget/card/address_card.dart';
import '../../widget/widget.dart';
import '../payment_method.dart/select_payment_method.dart';

class CheckoutPage extends StatefulWidget {
  final List<ChartEntity> products;

  const CheckoutPage({super.key, required this.products});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int handlingFee = 0;
  late CheckoutPayload checkoutPayload;
  int? total;

  bool isValid = false;
  bool useInsurance = false;
  bool isCod = false;

  ShippingEntity? selectedExpedition;
  ChartEntity? chart;
  ServiceDetailEntity? selectedService;
  PaymentMethod? _selectedPaymentMethod;
  AddressEntity? selectedAddress;

  int get totalProductPrice {
    return widget.products.fold(0, (sum, p) => sum + (p.price * p.qty));
  }

  double get insuranceFee {
    if (!useInsurance || selectedService == null) return 0;

    final insurancePercent = selectedService!.insurance;
    final basePrice = selectedService!.price;

    return basePrice * insurancePercent;
  }

  void _isValid() {
    setState(() {
      isValid = false;
    });
    if (selectedService == null) return;
    if (_selectedPaymentMethod == null) return;
    if (selectedAddress == null) return;

    setState(() {
      isValid = true;
    });
  }

  void pay() {
    debugPrint("===== CHECKOUT PAYLOAD =====");
    debugPrint(
      const JsonEncoder.withIndent('  ').convert(checkoutPayload.toJson()),
    );
    debugPrint("============================");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.common.white,
        title: Text(
          "Konfirmasi Pembayaran",
          style: TextStyle(color: AppColors.common.black),
        ),
        content: Text(
          "Apakah Anda yakin ingin melakukan pembayaran?",
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
              Navigator.pop(context);
              context.read<CheckoutCubit>().checkout(checkoutPayload);
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

  CheckoutPayload _buildCheckoutPayload(List<ChartEntity> products) {
    final cartIds = products.map((p) => p.id).toList();

    return CheckoutPayload(
      userId: products.isNotEmpty ? products.first.userId : null,
      pickupPointId: products.first.branch.pickupPoint?.id,
      originId: products.first.branch.pickupPoint?.originId,
      cartIds: cartIds,
      shipping: null,
    );
  }

  @override
  void initState() {
    super.initState();

    chart = widget.products.first;
    checkoutPayload = _buildCheckoutPayload(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) async {
        if (state is CheckoutLoading) {
          AppDialog.loading(context);
        }
        if (state is CheckoutError) {
          context.pop();
          showAppSnackBar(
            context,
            message: state.message,
            type: SnackType.error,
          );
        }
        if (state is CheckoutLoaded) {
          showAppSnackBar(
            context,
            message: "Berhasil Melakukan Checkout",
            type: SnackType.success,
          );
          await Future.delayed(const Duration(milliseconds: 300));
          PaymentData dataPayment = PaymentData(
            id: state.data,
            type: 'product',
            subMerchant: chart?.branch.subMerchant?.idMerchant ?? 0,
          );
          context.go('/payment-information', extra: dataPayment);
        }
      },
      child: ContainerScreen(
        title: "Pembayaran",
        scrollable: true,
        body: [
          _buildSectionTitle("Produk di pesan"),
          AppGap.height(8),
          ...widget.products.map((product) => _buildProductCard(product)),
          AppGap.height(16),

          _buildSectionTitle("Alamat Pengiriman"),
          AppGap.height(8),
          _buildAddressCard(),

          AppGap.height(16),
          _buildExpeditionCard(context),
          AppGap.height(16),
          _buildPaymentMethodCard(),

          if (selectedExpedition != null &&
              selectedService?.insurance != 0.0) ...[
            AppGap.height(8),
            Row(
              children: [
                Checkbox(
                  value: useInsurance,
                  activeColor: AppColors.light.primary,
                  checkColor: AppColors.common.white,
                  side: BorderSide(color: AppColors.common.grey400, width: 2),
                  onChanged: (val) {
                    setState(() {
                      useInsurance = val ?? false;

                      checkoutPayload = checkoutPayload.copyWith(
                        originId:
                            widget.products.first.branch.pickupPoint?.originId,
                        shipping: Shipping(
                          courierCode: selectedService!.serviceCode,
                          courierName: selectedExpedition!.courierName,
                          service: selectedService != null
                              ? Service(
                                  serviceCode: selectedService!.serviceCode,
                                  serviceName: selectedService!.service,
                                  estimation: selectedService!.etd,
                                  isInsurance: useInsurance,
                                  isCod: isCod,
                                )
                              : null,

                          address: checkoutPayload.shipping?.address,
                        ),
                      );
                    });
                  },
                ),
                Expanded(
                  child: AppText(
                    "Asuransi pengiriman ${TextFormatter.formatPercentage(selectedService!.insurance)}",
                    align: TextAlign.left,
                    weight: TextWeight.medium,
                    variant: TextVariant.body3,
                  ),
                ),
              ],
            ),
          ],

          AppGap.height(8),
          _buildPaymentSummaryCard(total ?? 0),
        ],
        bottomNavigationBar: _buildBottomButton(),
      ),
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
                text: "Bayar",
                onPressed: isValid == true ? () => pay() : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        AppText(
          title,
          variant: TextVariant.body2,
          weight: TextWeight.bold,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildProductCard(ChartEntity product) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.image.first,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          AppGap.width(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  product.productName,
                  variant: TextVariant.body2,
                  weight: TextWeight.semiBold,
                ),
                AppGap.height(4),
                AppText(
                  TextFormatter.formatRupiah(product.price),
                  color: AppColors.light.primary,
                  variant: TextVariant.body1,
                  weight: TextWeight.semiBold,
                ),
                AppGap.height(4),
                if (product.variant?.id != 0 &&
                    product.variant!.name.isNotEmpty)
                  AppText(
                    "${product.variant!.name}/ ${product.variantSize!.size}",
                    variant: TextVariant.body3,
                    color: Colors.grey.shade600,
                  ),
                AppGap.height(4),
                AppText("Qty: ${product.qty}", variant: TextVariant.body3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return GestureDetector(
      onTap: () async {
        final selected = await context.push<AddressEntity>(
          '/list-address',
          extra: true,
        );

        if (selected != null) {
          setState(() {
            selectedAddress = selected;

            checkoutPayload = checkoutPayload.copyWith(
              originId: widget.products.first.branch.pickupPoint?.originId,
              destinationId: selectedAddress!.districtId,
              shipping: (checkoutPayload.shipping ?? Shipping()).copyWith(
                address: Address(
                  receiverName: selected.name,
                  phone: selected.phoneNumber.toString(),
                  address: selected.fullAddress,
                  latitude: selected.latitude != 0.0 ? selected.latitude : null,
                  longitude: selected.longitude != 0.0
                      ? selected.longitude
                      : null,
                ),
              ),
            );
          });
        }

        _isValid();
      },
      child: selectedAddress != null
          ? AddressCard(
              name: selectedAddress?.name ?? "-",
              phone: selectedAddress?.phoneNumber ?? 0,
              address: selectedAddress?.fullAddress ?? "-",
              isPrimary: selectedAddress?.isDefault ?? false,
            )
          : Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.home_outlined, color: AppColors.light.primary),
                  AppGap.width(12),
                  AppText(
                    "Pilih Alamat Pengiriman",
                    maxLines: 2,
                    align: TextAlign.left,
                    weight: TextWeight.medium,
                    variant: TextVariant.body3,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildExpeditionCard(BuildContext context) {
    return _buildOptionCard(
      icon: Icons.local_shipping_outlined,
      title: selectedAddress == null
          ? "Pilih alamat terlebih dahulu"
          : selectedExpedition != null && selectedService != null
          ? "${selectedExpedition!.courierName} - ${selectedService!.service} (${selectedService!.duration})\n${selectedService!.etd}"
          : "Pilih Ekspedisi",
      onTap: selectedAddress == null
          ? () {}
          : () async {
              ShippingParams params = ShippingParams(
                cartIds: widget.products.map((e) => e.id).toList(),
                destinationId: selectedAddress!.districtId,
                qty: widget.products[0].qty,
                pickupPointId:
                    widget.products.first.branch.pickupPoint?.id ?? 0,
                originId:
                    widget.products.first.branch.pickupPoint?.originId ?? 0,
              );

              final result = await context.push<ShippingEntity>(
                '/select-expedition',
                extra: params,
              );

              if (result != null) {
                setState(() {
                  useInsurance = true;
                  selectedExpedition = result;
                  selectedService = result.serviceDetail.isNotEmpty
                      ? result.serviceDetail.first
                      : null;

                  checkoutPayload = checkoutPayload.copyWith(
                    originId:
                        widget.products.first.branch.pickupPoint?.originId,
                    shipping: Shipping(
                      courierCode: selectedService!.serviceCode,
                      courierName: selectedExpedition!.courierName,
                      service: selectedService != null
                          ? Service(
                              serviceCode: selectedService!.serviceCode,
                              serviceName: selectedService!.service,
                              estimation: selectedService!.etd,
                              isInsurance: useInsurance,
                              isCod: isCod,
                            )
                          : null,

                      address: checkoutPayload.shipping?.address,
                    ),
                  );
                });
              }

              _isValid();
            },
    );
  }

  Widget _buildPaymentMethodCard() {
    return _buildOptionCard(
      icon: Icons.payment_outlined,
      title: _selectedPaymentMethod?.name ?? "Metode Pembayaran",

      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SelectPaymentMethodPage(methods: dummyPaymentMethods),
          ),
        );

        if (result != null && result is PaymentMethod) {
          setState(() {
            _selectedPaymentMethod = result;
          });
          _isValid();
        }
      },
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.light.primary),
            AppGap.width(12),
            Expanded(
              child: AppText(
                title,
                maxLines: 2,
                align: TextAlign.left,
                weight: TextWeight.medium,
                variant: TextVariant.body3,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard(int total) {
    final shippingCost = selectedService?.price ?? 0;
    final feeInsurance = insuranceFee.round();

    total = totalProductPrice + handlingFee + shippingCost + feeInsurance;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            "Sub Total Produk",
            TextFormatter.formatRupiah(totalProductPrice),
          ),

          // _buildSummaryRow(
          //   "Biaya Penanganan",
          //   TextFormatter.formatRupiah(handlingFee),
          // ),
          if (useInsurance)
            _buildSummaryRow(
              "Biaya Asuransi (${TextFormatter.formatPercentage(selectedService!.insurance)} x ${TextFormatter.formatRupiah(selectedService!.price)})",
              TextFormatter.formatRupiah(feeInsurance),
            ),
          if (selectedService != null)
            _buildSummaryRow(
              "Biaya Pengiriman (${selectedExpedition?.courierName ?? '-'})",
              TextFormatter.formatRupiah(shippingCost),
            ),

          const Divider(),

          _buildSummaryRow(
            "Total Pembayaran",
            TextFormatter.formatRupiah(total),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            variant: isTotal ? TextVariant.body2 : TextVariant.body3,
            weight: isTotal ? TextWeight.bold : TextWeight.medium,
          ),
          AppText(
            value,
            variant: isTotal ? TextVariant.body2 : TextVariant.body3,
            color: isTotal ? AppColors.light.primary : Colors.grey.shade800,
            weight: isTotal ? TextWeight.bold : TextWeight.medium,
          ),
        ],
      ),
    );
  }
}
