import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:kas_autocare_user/data/dummy/detail_product_dummy.dart';
import 'package:kas_autocare_user/domain/entities/product_entity.dart';
import 'package:kas_autocare_user/domain/usecase/add_to_chart.dart';
import 'package:kas_autocare_user/presentation/cubit/add_tochart_cubit.dart';
import 'package:kas_autocare_user/presentation/cubit/detail_product_cubit.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/inject/depedency_injection.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';

import '../../../data/model/product_dummy_model.dart';
import '../../cubit/cart_cubit.dart';
import '../../widget/bottomsheet/add_to_cart_sheet.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  VariantEntity? _selectedVariant;
  SizeEntity? _selectedSize;

  Future<void> _showAddToCartBottomSheet(
    BuildContext context,
    ProductEntity product,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider(
          create: (context) => AddToCartCubit(sl<AddToChart>()),
          child: AddToCartSheet(
            product: product,
            onAdded: () {
              fetchChart();
            },
          ),
        );
      },
    );
  }

  void fetchChart() async {
    context.read<CartCubit>().fetchCart();
  }

  Future<void> _showBuyProductBottomSheet(
    BuildContext context,
    ProductEntity product,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider(
          create: (context) => AddToCartCubit(sl<AddToChart>()),
          child: BuyProductSheet(product: product),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.common.white,
      bottomNavigationBar: BlocBuilder<DetailProductCubit, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductLoading) {
            return Center(child: AppCircularLoading());
          }

          if (state is DetailProductError) {
            return Center(child: Text(state.message));
          }
          if (state is DetailProductSuccess) {
            ProductEntity product = state.product;

            if (_selectedVariant == null && product.variants.isNotEmpty) {
              _selectedVariant = product.variants.first;
              if (_selectedVariant!.sizes.isNotEmpty) {
                _selectedSize = _selectedVariant!.sizes.first;
              }
            }
            return _buildBottomButton(context, product);
          }
          return SizedBox.shrink();
        },
      ),
      body: BlocBuilder<DetailProductCubit, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductLoading) {
            return Center(child: AppCircularLoading());
          }

          if (state is DetailProductError) {
            return Center(child: Text(state.message));
          }
          if (state is DetailProductSuccess) {
            ProductEntity product = state.product;

            if (_selectedVariant == null && product.variants.isNotEmpty) {
              _selectedVariant = product.variants.first;
              if (_selectedVariant!.sizes.isNotEmpty) {
                _selectedSize = _selectedVariant!.sizes.first;
              }
            }
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: PageView.builder(
                            itemCount: product.image.length,
                            onPageChanged: (index) {
                              setState(() => _currentImageIndex = index);
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                product.image[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.image.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: _currentImageIndex == index ? 10 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == index
                                      ? AppColors.light.primary
                                      : Colors.grey[400],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _buildAppbarDetail(context),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            product.name,
                            variant: TextVariant.heading7,
                            weight: TextWeight.bold,
                          ),
                          AppGap.height(4),
                          AppText(
                            TextFormatter.formatRupiah(product.price),
                            color: AppColors.light.primary,
                            variant: TextVariant.body1,
                            weight: TextWeight.semiBold,
                          ),

                          AppGap.height(8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: AppColors.light.error,
                              ),
                              AppGap.width(4),
                              AppText(
                                product.branch.city,
                                variant: TextVariant.body3,
                                color: Colors.black87,
                                weight: TextWeight.medium,
                              ),
                              const Spacer(),
                              Icon(Icons.star, size: 20, color: Colors.amber),
                              AppGap.width(4),
                              AppText(
                                product.businessUnitId.toString(),
                                variant: TextVariant.body2,
                                weight: TextWeight.bold,
                              ),
                            ],
                          ),

                          AppGap.height(16),

                          // ---------- VARIANT ----------
                          if (product.variants.isNotEmpty) ...[
                            _buildSectionTitle('Variant'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: product.variants.map((variant) {
                                final isSelected =
                                    _selectedVariant?.id == variant.id;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedVariant = variant;
                                      // reset size ke pertama dari variant baru
                                      if (variant.sizes.isNotEmpty) {
                                        _selectedSize = variant.sizes.first;
                                      } else {
                                        _selectedSize = null;
                                      }
                                    });
                                  },
                                  child: _buildChip(
                                    variant.name,
                                    selected: isSelected,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // ---------- SIZE ----------
                          if (_selectedVariant != null &&
                              _selectedVariant!.sizes.isNotEmpty) ...[
                            _buildSectionTitle('Size'),
                            const SizedBox(height: 8),
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
                                  child: _buildChip(
                                    size.size,
                                    selected: isSelected,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          // Wrap(
                          //   spacing: 8,
                          //   children: product.tags
                          //       .map((t) => _buildChip(t, selected: false))
                          //       .toList(),
                          // ),
                          AppGap.height(16),
                          _buildSectionTitle("Informasi Produk"),
                          AppGap.height(4),
                          ExpandableText(
                            text: product.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),

                          AppGap.height(18),
                          // Row(
                          //   children: [
                          //     _buildSectionTitle("Rating & Reviews 10"),
                          //     Spacer(),
                          //     GestureDetector(
                          //       onTap: () => context.push('/reviews-product'),
                          //       child: AppText(
                          //         'Lihat Semua',
                          //         variant: TextVariant.body2,
                          //         weight: TextWeight.medium,
                          //         color: AppColors.light.primary,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     RatingBarIndicator(
                          //       rating: 3.4,
                          //       itemCount: 5,
                          //       itemSize: 18,
                          //       itemBuilder: (_, __) =>
                          //           const Icon(Icons.star, color: Colors.amber),
                          //     ),
                          //     AppGap.width(8),
                          //     AppText('3.0', variant: TextVariant.body3),
                          //   ],
                          // ),

                          // AppGap.height(16),
                          // ...dummyP.reviews.take(3).map(_buildReviewItem),
                          // AppGap.height(16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAppbarDetail(BuildContext context) {
    return Positioned(
      top: 8,
      child: Container(
        padding: AppPadding.all(16),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: CircleAvatar(
                radius: 17,
                child: Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),

            GestureDetector(
              onTap: () async {
                final res = await context.push('/chart');
                if (res != null) {
                  fetchChart();
                } else {
                  fetchChart();
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(AppIcons.cartIcon, width: 40, height: 40),

                  Positioned(
                    right: -4,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          if (state is CartLoading) {
                            return Center(
                              child: AppText(
                                '-',
                                variant: TextVariant.body3,
                                color: AppColors.common.white,
                              ),
                            );
                          }

                          if (state is CartError) {
                            return Center(
                              child: AppText(
                                'E',
                                variant: TextVariant.body3,
                                color: AppColors.common.white,
                              ),
                            );
                          }

                          if (state is CartLoaded) {
                            final cartItems = state.cartItems;
                            return Center(
                              child: AppText(
                                '${cartItems.length}',
                                variant: TextVariant.body3,
                                color: AppColors.common.white,
                              ),
                            );
                          }

                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _buildBottomButton(BuildContext context, ProductEntity product) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //       child: AppElevatedButton(
            //         height: 38.0.rheight,
            //         text: "Beli Produk",
            //         onPressed: () {
            //           _showBuyProductBottomSheet(context, product);
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    height: 38.0.rheight,
                    text: "Tambah Keranjang",
                    onPressed: () {
                      _showAddToCartBottomSheet(context, product);
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

  Widget _buildReviewItem(ProductReview r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RatingBarIndicator(
              rating: r.rating,
              itemCount: 5,
              itemSize: 14,
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: Colors.amber),
            ),
            AppGap.width(8),
            AppText(
              r.reviewer,

              weight: TextWeight.medium,
              variant: TextVariant.body3,
            ),
            const Spacer(),
            AppText(r.date, color: Colors.grey, variant: TextVariant.body3),
          ],
        ),
        AppGap.height(4),
        AppText(
          r.review,
          align: TextAlign.left,
          variant: TextVariant.body3,
          color: Colors.black87,
        ),
        if (r.photos != null && r.photos!.isNotEmpty) ...[
          AppGap.height(8),
          Row(
            children: r.photos!
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        p,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        AppGap.height(16),
      ],
    );
  }

  Widget _buildChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.light.primary : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.light.primary : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AppText(
        label,
        color: selected ? Colors.white : Colors.black87,
        variant: TextVariant.body3,
      ),
    );
  }

  Widget _buildSectionTitle(String title) =>
      AppText(title, variant: TextVariant.body2, weight: TextWeight.bold);
}
