import 'package:flutter/material.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../domain/entities/chart_entity.dart';
import '../widget.dart';

class CartItemBase extends StatelessWidget {
  final ChartEntity product;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final VoidCallback onIncreaseQty;
  final VoidCallback onDecreaseQty;
  final VoidCallback onDelete;
  final VoidCallback onTapProduct;

  const CartItemBase({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onToggleSelect,
    required this.onIncreaseQty,
    required this.onDecreaseQty,
    required this.onDelete,
    required this.onTapProduct,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product.image.isNotEmpty) ? product.image.first : null;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.common.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.common.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTapProduct,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: AppColors.light.primary,
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
          ),
          AppGap.width(10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: onTapProduct,
                  child: AppText(
                    align: TextAlign.left,
                    product.productName,
                    weight: TextWeight.bold,
                    variant: TextVariant.body2,
                  ),
                ),
                AppGap.height(2),
                AppText(
                  TextFormatter.formatRupiah(product.price),
                  color: AppColors.light.primary,
                  weight: TextWeight.bold,
                  variant: TextVariant.body2,
                ),
                AppGap.height(2),
                if (product.variantName.isNotEmpty &&
                    product.variantSizeName.isNotEmpty)
                  AppText(
                    "${product.variantName} / ${product.variantSizeName}",
                    color: AppColors.common.grey500,
                    variant: TextVariant.body3,
                  ),
                AppGap.height(8),
                AppText(
                  "min order : ${product.branchProduct.minOrder}",
                  color: AppColors.common.grey500,
                  variant: TextVariant.body3,
                ),
                AppText(
                  "max order : ${product.branchProduct.maxOrder}",
                  color: AppColors.common.grey500,
                  variant: TextVariant.body3,
                  weight: TextWeight.medium,
                ),
                AppGap.height(8),

                Row(
                  children: [
                    _qtyButton(Icons.remove, onDecreaseQty),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AppText(
                        product.qty.toString(),
                        weight: TextWeight.bold,
                        variant: TextVariant.body2,
                      ),
                    ),
                    _qtyButton(Icons.add, onIncreaseQty),
                    const Spacer(),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline,

                        color: AppColors.light.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: (_) => onToggleSelect(),
            activeColor: AppColors.light.primary,
            checkColor: AppColors.common.white,

            side: BorderSide(color: AppColors.common.grey400, width: 2),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.light.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.common.white),
      ),
    );
  }
}
