import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../data/params/update_chart_params.dart';
import '../../../domain/entities/chart_entity.dart';
import '../../cubit/cart_cubit.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Set<int> _selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  void _toggleSelectAll(bool? value, List<ChartEntity> cartItems) {
    setState(() {
      if (value == true) {
        _selectedIndexes.addAll(List.generate(cartItems.length, (i) => i));
      } else {
        _selectedIndexes.clear();
      }
    });
  }

  void _toggleSelect(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  int _calculateTotal(List<ChartEntity> cartItems) {
    int total = 0;
    for (int i in _selectedIndexes) {
      total += cartItems[i].price * cartItems[i].qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return ContainerScreen(
            title: "Keranjang",
            scrollable: false,
            body: [Center(child: AppCircularLoading())],
          );
        }

        if (state is CartLoaded) {
          final cartItems = state.cartItems;

          if (cartItems.isEmpty) {
            return ContainerScreen(
              title: "Keranjang",
              body: [const Center(child: Text("Keranjang kosong"))],
              scrollable: false,
            );
          }

          final total = _calculateTotal(cartItems);

          return ContainerScreen(
            title: "Keranjang",
            scrollable: true,

            bottomNavigationBar: _buildBottomButton(cartItems, total),

            body: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final chart = cartItems[index];

                  // Hitung available stock dengan benar tanpa setState
                  final int availableStock = chart.variantSize?.createdBy != 0
                      ? (chart.variantSize?.stock ?? 0)
                      : chart.branchProduct.stock;

                  final int minQty = chart.branchProduct.minOrder;
                  int maxQty = chart.branchProduct.maxOrder;

                  // batas atas tidak boleh lebih dari stock
                  if (availableStock < maxQty) {
                    maxQty = availableStock;
                  }

                  // pastikan clamp aman: jika min > max maka set max = min
                  if (minQty > maxQty) {
                    maxQty = minQty;
                  }

                  // Flags untuk UI (boleh disable tombol + / - di CartItemBase)
                  final bool canIncrease = availableStock < maxQty;
                  final bool canDecrease = availableStock > minQty;

                  return CartItemBase(
                    product: chart,
                    isSelected: _selectedIndexes.contains(index),
                    onToggleSelect: () => _toggleSelect(index),
                    onIncreaseQty: () {
                      // if (!canIncrease) {

                      //   return;
                      // }

                      final int limit = maxQty < availableStock
                          ? maxQty
                          : availableStock;

                      if (chart.qty >= limit) return;

                      final int newQty = chart.qty + 1;

                      context.read<CartCubit>().updateCartItem(
                        chartId: chart.id,
                        params: UpdateChartParams(
                          qty: newQty,
                          branchProductNewsId: chart.branchProductNewsId,
                          variantProductNewsId: chart.variant?.id ?? 0,
                          variantProductSizeNewsId: chart.variantSize?.id ?? 0,
                        ),
                      );
                    },

                    onDecreaseQty: () {
                      // if (!canDecrease) {
                      //   return;
                      // }

                      if (chart.qty <= minQty) return;

                      final int newQty = chart.qty - 1;

                      context.read<CartCubit>().updateCartItem(
                        chartId: chart.id,
                        params: UpdateChartParams(
                          qty: newQty,
                          branchProductNewsId: chart.branchProductNewsId,
                          variantProductNewsId: chart.variant?.id ?? 0,
                          variantProductSizeNewsId: chart.variantSize?.id ?? 0,
                        ),
                      );
                    },

                    onDelete: () =>
                        context.read<CartCubit>().removeFromCart(chart.id),
                    onTapProduct: () => context.push(
                      '/detail-product',
                      extra: chart.branchProductNewsId,
                    ),
                  );
                },
              ),
            ],
          );
        }

        if (state is CartError) {
          return ContainerScreen(
            title: "Keranjang",
            scrollable: false,
            body: [Center(child: Text('Error: ${state.message}'))],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildBottomButton(List<ChartEntity> cartItems, int total) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.common.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Checkbox(
                  value:
                      _selectedIndexes.length == cartItems.length &&
                      cartItems.isNotEmpty,
                  onChanged: (value) => _toggleSelectAll(value, cartItems),
                  activeColor: AppColors.light.primary,
                  checkColor: AppColors.common.white,

                  side: BorderSide(color: AppColors.common.grey400, width: 2),
                ),
                AppText(
                  "Semua",
                  variant: TextVariant.body2,
                  weight: TextWeight.bold,
                ),
              ],
            ),
            Container(
              padding: AppPadding.all(16),
              decoration: BoxDecoration(
                color: AppColors.light.primary30,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    "Total Harga",
                    weight: TextWeight.bold,
                    variant: TextVariant.body2,
                    color: AppColors.common.black,
                  ),
                  AppText(
                    TextFormatter.formatRupiah(total),
                    weight: TextWeight.bold,
                    color: AppColors.common.black,
                    variant: TextVariant.body2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AppElevatedButton(
              text: "Beli (${_selectedIndexes.length})",
              onPressed: _selectedIndexes.isEmpty
                  ? null
                  : () {
                      final selectedProducts = _selectedIndexes
                          .map((i) => cartItems[i])
                          .toList();
                      context.push('/checkout', extra: selectedProducts);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
