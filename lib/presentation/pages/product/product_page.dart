import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/assets/app_icons.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../domain/entities/product_entity.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/product_cubit.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ProductEntity> allProducts = [];
  List<ProductEntity> filteredProducts = [];

  String? selectedCity;
  String? selectedSaleType;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    // context.read<ProductCubit>().getInitialProducts();
    super.initState();
    _searchController.addListener(() {
      _searchProducts(_searchController.text);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<ProductCubit>().loadMoreProducts();
      }
    });
  }

  void fetchChart() async {
    context.read<CartCubit>().fetchCart();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerScreen(
      rightButton: _rightButtonProduct(),
      title: 'Produk',
      scrollable: false,
      body: [
        BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Expanded(child: Center(child: AppCircularLoading()));
            }

            if (state is ProductError) {
              return Expanded(child: Center(child: Text(state.message)));
            }

            if (state is ProductLoaded) {
              allProducts = state.products;

              if (_searchController.text.isEmpty) {
                filteredProducts = allProducts;
              }

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () async {
                        //     final result =
                        //         await showModalBottomSheet<
                        //           Map<String, dynamic>?
                        //         >(
                        //           context: context,
                        //           isScrollControlled: true,
                        //           backgroundColor: Colors.white,
                        //           shape: const RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.vertical(
                        //               top: Radius.circular(16),
                        //             ),
                        //           ),
                        //           builder: (_) => FilterProductBottomSheet(
                        //             initialCity: selectedCity,
                        //             initialSaleType: selectedSaleType,
                        //             initialPaymentMethod: selectedPaymentMethod,
                        //           ),
                        //         );

                        //     if (result != null) {
                        //       setState(() {
                        //         selectedCity = result['city'];
                        //         selectedSaleType = result['saleType'];
                        //         selectedPaymentMethod = result['paymentMethod'];
                        //       });

                        //       // Terapkan filter ke Cubit
                        //       // context.read<ProductCubit>().applyFilter(
                        //       //   city: selectedCity,
                        //       //   merchantType: selectedSaleType,
                        //       //   paymentMethod: selectedPaymentMethod,
                        //       // );
                        //     }
                        //   },
                        //   child: Container(
                        //     height: 48,
                        //     width: 48,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(10),
                        //       border: Border.all(
                        //         color: Colors.grey.shade300,
                        //         width: 1.5,
                        //       ),
                        //     ),
                        //     child: Icon(
                        //       Icons.filter_alt_outlined,
                        //       color: AppColors.common.black,
                        //     ),
                        //   ),
                        // ),
                        // AppGap.width(8),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              onSubmitted: (value) {
                                final query = value.trim();

                                if (query.isEmpty) {
                                  context
                                      .read<ProductCubit>()
                                      .resetFilterAndSearch();
                                } else {
                                  context.read<ProductCubit>().applySearch(
                                    query,
                                  );
                                }
                              },
                              controller: _searchController,
                              style: TextStyle(
                                color: AppColors.common.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (value) => _searchProducts(value),
                              cursorColor: AppColors.light.primary,
                              decoration: InputDecoration(
                                hintText: 'Cari Produk',
                                hintStyle: TextStyle(
                                  color: AppColors.common.black,
                                ),
                                suffixIcon: AppIcon(
                                  icon: Icons.search,
                                  color: AppColors.common.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppGap.height(20),
                    Expanded(
                      child: MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () async {
                              final res = await context.push(
                                '/detail-product',
                                extra: product.id,
                              );
                              if (res != null) {
                                fetchChart();
                              } else {
                                fetchChart();
                              }
                            },
                            child: ProductCard(
                              imageUrl: product.image.isNotEmpty
                                  ? product.image.first
                                  : '',
                              title: product.name,
                              location: product.branch.city,
                              price: product.price,
                              rating: 4.8,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Expanded(child: SizedBox());
          },
        ),
      ],
    );
  }

  Widget _rightButtonProduct() {
    return GestureDetector(
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
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
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
    );
  }
}
