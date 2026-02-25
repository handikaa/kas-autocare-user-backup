import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/params/add_tochart_params.dart';
import '../../../domain/entities/chart_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../cubit/add_tochart_cubit.dart';
import '../widget.dart';

class AddToCartSheet extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback onAdded;
  const AddToCartSheet({
    super.key,
    required this.product,
    required this.onAdded,
  });

  @override
  State<AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<AddToCartSheet> {
  int quantity = 1;
  int stockavailable = 0;

  VariantEntity? _selectedVariant;
  SizeEntity? _selectedSize;

  @override
  void initState() {
    super.initState();

    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants.first;
      if (_selectedVariant!.sizes.isNotEmpty) {
        _selectedSize = _selectedVariant!.sizes.first;
        stockavailable = _selectedSize!.stock;
      }
    } else {
      stockavailable = widget.product.stock;
    }

    quantity = widget.product.minOrder;
  }

  bool get isAddDisabled {
    if (activeStock <= 0) return true;
    if (quantity == 0) return true;
    return false;
  }

  int get activeStock {
    if (widget.product.variants.isEmpty) {
      return widget.product.stock;
    }

    if (_selectedSize != null) {
      return _selectedSize!.stock;
    }

    return 0;
  }

  void _decreaseQty() {
    if (quantity > widget.product.minOrder) {
      setState(() => quantity--);
    }
  }

  void _increaseQty() {
    final maxAllowed = _getMaxQuantity();
    if (quantity < maxAllowed) {
      setState(() => quantity++);
    }
  }

  int _getMaxQuantity() {
    final maxOrder = widget.product.maxOrder;
    final stock = activeStock;

    return stock <= 0 ? 0 : (stock < maxOrder ? stock : maxOrder);
  }

  int get _calculatedPrice {
    int basePrice = 0;

    if (_selectedVariant != null) {
      if (_selectedSize != null) {
        basePrice = _selectedSize!.price;
      } else if (_selectedVariant!.sizes.isNotEmpty) {
        basePrice = _selectedVariant!.sizes.first.price;
      }
    } else {
      basePrice = widget.product.price;
    }

    return basePrice * quantity;
  }

  void _handleAddToCart() {
    final params = AddChartParams(
      branchId: widget.product.branch.id,
      bussinesId: widget.product.branch.bussinesId,

      branchProductNewsId: widget.product.id,
      variantId: _selectedVariant?.id,
      variantSizeId: _selectedSize?.id,
      userId: 384,
      qty: quantity,
    );

    debugPrint("===== ADD CHART PAYLOAD =====");
    debugPrint(const JsonEncoder.withIndent('  ').convert(params.toJson()));
    debugPrint("============================");

    context.read<AddToCartCubit>().addToCart(params);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              AppGap.width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      align: TextAlign.left,
                      product.name,
                      variant: TextVariant.body1,
                      weight: TextWeight.bold,
                    ),
                    AppGap.height(4),
                    AppText(
                      TextFormatter.formatRupiah(_calculatedPrice),
                      variant: TextVariant.body2,
                      weight: TextWeight.bold,
                    ),
                    if (_selectedVariant != null)
                      AppText(
                        [
                          _selectedVariant?.name,
                          _selectedSize?.size,
                        ].whereType<String>().join(' / '),
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                        color: AppColors.common.grey500,
                      ),

                    AppGap.height(4),
                    if (stockavailable >= 10 && stockavailable != 0)
                      AppText(
                        "Stok tersedia $stockavailable",
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                        color: AppColors.light.primary,
                      ),
                    if (stockavailable <= 10 && stockavailable != 0)
                      AppText(
                        "Stok tersedia $stockavailable",
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                        color: AppColors.light.error,
                      ),
                    AppText(
                      "Minimun Order ${widget.product.minOrder}",
                      variant: TextVariant.body3,
                      weight: TextWeight.medium,
                      color: AppColors.light.error,
                    ),

                    if (stockavailable == 0)
                      AppText(
                        "Stok habis",
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                        color: AppColors.light.error,
                      ),
                  ],
                ),
              ),
            ],
          ),

          AppGap.height(16),

          Row(
            children: [
              IconButton(
                onPressed: quantity > widget.product.minOrder
                    ? _decreaseQty
                    : null,
                icon: AppIcon(
                  icon: Icons.remove_circle_outline,
                  color: AppColors.common.black,
                ),
              ),

              AppText(
                quantity.toString(),
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),

              IconButton(
                onPressed: quantity < _getMaxQuantity() ? _increaseQty : null,
                icon: AppIcon(
                  icon: Icons.add_circle_outline,
                  color: AppColors.common.black,
                ),
              ),
            ],
          ),

          if (product.variants.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                "Variant",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),
            ),
            AppGap.height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.variants.map((variant) {
                    final isSelected = _selectedVariant?.id == variant.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVariant = variant;
                          _selectedSize = variant.sizes.isNotEmpty
                              ? variant.sizes.first
                              : null;

                          stockavailable = _selectedSize?.stock ?? 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.light.primary
                              : AppColors.common.grey200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppText(
                          variant.name,
                          variant: TextVariant.body2,
                          weight: TextWeight.regular,
                          color: isSelected
                              ? AppColors.common.white
                              : AppColors.common.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            AppGap.height(16),
          ],

          if (_selectedVariant != null &&
              _selectedVariant!.sizes.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                "Size",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),
            ),
            AppGap.height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedVariant!.sizes.map((size) {
                    final isSelected = _selectedSize?.id == size.id;
                    final outOfStock = size.stock == 0;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSize = size;
                          stockavailable = size.stock;
                          if (outOfStock) {
                            quantity = 0;
                          } else {
                            quantity = widget.product.minOrder;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: (isSelected
                              ? AppColors.light.primary
                              : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: outOfStock
                                ? Colors.red.shade300
                                : Colors.transparent,
                            width: outOfStock ? 1.2 : 0,
                          ),
                        ),
                        child: AppText(
                          "${size.size} (${size.stock})",
                          weight: TextWeight.regular,
                          color: (isSelected ? Colors.white : Colors.black),
                          variant: TextVariant.body2,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            AppGap.height(16),
          ],

          AppGap.height(24),

          BlocListener<AddToCartCubit, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartSuccess) {
                showAppSnackBar(
                  context,
                  message: "Produk berhasil ditambahkan ke keranjang",
                  type: SnackType.success,
                );
                widget.onAdded();
                context.pop();
              }

              if (state is AddToCartError) {
                context.pop();
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackType.error,
                );
              }
            },
            child: BlocBuilder<AddToCartCubit, AddToCartState>(
              builder: (context, state) {
                final isLoading = state is AddToCartLoading;

                return SafeArea(
                  child: AppElevatedButton(
                    text: stockavailable < quantity
                        ? "Stok kurang dari minimun order"
                        : isLoading
                        ? "Menambahkan..."
                        : isAddDisabled
                        ? "Stok Kosong"
                        : "Tambahkan ke Keranjang",
                    onPressed: stockavailable < quantity
                        ? null
                        : isLoading || isAddDisabled
                        ? null
                        : () => _handleAddToCart(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BuyProductSheet extends StatefulWidget {
  final ProductEntity product;
  const BuyProductSheet({super.key, required this.product});

  @override
  State<BuyProductSheet> createState() => BuyProducttSheetState();
}

class BuyProducttSheetState extends State<BuyProductSheet> {
  int quantity = 1;

  VariantEntity? _selectedVariant;
  SizeEntity? _selectedSize;

  @override
  void initState() {
    super.initState();

    if (widget.product.variants.isNotEmpty) {
      _selectedVariant = widget.product.variants.first;
      if (_selectedVariant!.sizes.isNotEmpty) {
        _selectedSize = _selectedVariant!.sizes.first;
      }
    }
  }

  int get _calculatedPrice {
    int basePrice = 0;

    if (_selectedVariant != null) {
      if (_selectedSize != null) {
        basePrice = _selectedSize!.price;
      } else if (_selectedVariant!.sizes.isNotEmpty) {
        basePrice = _selectedVariant!.sizes.first.price;
      }
    } else {
      basePrice = widget.product.price;
    }

    return basePrice * quantity;
  }

  void _handleBuyProduct() {
    List<ChartEntity>? data = [
      ChartEntity(
        id: widget.product.id,
        branchId: widget.product.branch.id,
        bussinesId: widget.product.bussinesId,
        businessUnitId: widget.product.businessUnitId,
        branchProductNewsId: widget.product.id,
        userId: 384,
        customerId: 0,
        productName: widget.product.name,
        variantName: _selectedVariant?.name ?? '',
        variantSizeName: _selectedSize?.size ?? '',
        image: widget.product.image,
        qty: quantity,
        price: widget.product.price,
        totalPrice: _calculatedPrice,
        type: widget.product.type,
        variantProductNewsId: _selectedVariant?.id ?? 0,
        variantProductSizeNewsId: _selectedSize?.id ?? 0,
        branch: widget.product.branch,
        branchProduct: BranchProductEntity(
          id: 0,
          name: '',
          price: 0,
          image: [],
          minOrder: 0,
          maxOrder: 0,
          stock: 0,
          isCod: false,
        ),
        variant: _selectedVariant,
        variantSize: _selectedSize,
        user: null,
        customer: CustomerEntity(id: 0, username: '', phone: ''),
      ),
    ];

    context.push('/checkout', extra: data);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              AppGap.width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      align: TextAlign.left,
                      product.name,
                      variant: TextVariant.body1,
                      weight: TextWeight.bold,
                    ),
                    AppGap.height(4),
                    AppText(
                      TextFormatter.formatRupiah(_calculatedPrice),
                      variant: TextVariant.body2,
                      weight: TextWeight.bold,
                    ),

                    AppGap.height(4),

                    if (_selectedVariant != null)
                      AppText(
                        [
                          _selectedVariant?.name,
                          _selectedSize?.size,
                        ].whereType<String>().join(' / '),
                        variant: TextVariant.body3,
                        weight: TextWeight.medium,
                        color: AppColors.common.grey500,
                      ),
                  ],
                ),
              ),
            ],
          ),

          AppGap.height(16),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: quantity > 1
                    ? () => setState(() => quantity--)
                    : null,
                icon: AppIcon(
                  icon: Icons.remove_circle_outline,
                  color: quantity > 1
                      ? AppColors.common.black
                      : AppColors.common.grey400,
                ),
              ),
              AppText(
                quantity.toString(),
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),

              IconButton(
                onPressed: () => setState(() => quantity++),
                icon: AppIcon(
                  icon: Icons.add_circle_outline,
                  size: 15,
                  color: AppColors.common.black,
                ),
              ),
            ],
          ),

          if (product.variants.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                "Variant",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),
            ),
            AppGap.height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.variants.map((variant) {
                    final isSelected = _selectedVariant?.id == variant.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVariant = variant;
                          _selectedSize = variant.sizes.isNotEmpty
                              ? variant.sizes.first
                              : null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.light.primary
                              : AppColors.common.grey200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppText(
                          variant.name,
                          variant: TextVariant.body2,
                          weight: TextWeight.regular,
                          color: isSelected
                              ? AppColors.common.white
                              : AppColors.common.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            AppGap.height(16),
          ],

          if (_selectedVariant != null &&
              _selectedVariant!.sizes.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: AppText(
                "Size",
                variant: TextVariant.body2,
                weight: TextWeight.medium,
              ),
            ),
            AppGap.height(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedVariant!.sizes.map((size) {
                    final isSelected = _selectedSize?.id == size.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSize = size;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.light.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppText(
                          size.size,
                          variant: TextVariant.body2,
                          weight: TextWeight.regular,
                          color: isSelected
                              ? AppColors.common.white
                              : AppColors.common.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            AppGap.height(16),
          ],

          AppGap.height(24),

          BlocListener<AddToCartCubit, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message.isNotEmpty
                          ? state.message
                          : "Produk berhasil ditambahkan ke keranjang",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                context.pop();
              }

              if (state is AddToCartError) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<AddToCartCubit, AddToCartState>(
              builder: (context, state) {
                final isLoading = state is AddToCartLoading;

                return SafeArea(
                  child: AppElevatedButton(
                    text: isLoading ? "Menambahkan..." : "Beli Produk",
                    onPressed: isLoading ? null : () => _handleBuyProduct(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
