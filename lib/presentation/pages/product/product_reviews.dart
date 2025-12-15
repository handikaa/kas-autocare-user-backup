import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_style.dart';
import '../../../data/dummy/reviews_dummy.dart';
import '../../../data/model/review.dart';
import '../../widget/icon/app_circular_loading.dart';
import '../../widget/widget.dart';

class ProductReviewsPage extends StatefulWidget {
  const ProductReviewsPage({super.key});

  @override
  State<ProductReviewsPage> createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  List<Review> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      reviews = dummyReviews;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalReviews = reviews.length;
    final averageRating = totalReviews > 0
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews
        : 0.0;
    final summary = _ratingSummary(reviews);

    return ContainerScreen(
      usePadding: false,
      scrollable: true,
      title: "Ulasan",
      body: [
        if (isLoading)
          const Center(child: AppCircularLoading())
        else ...[
          Container(
            decoration: BoxDecoration(
              color: AppColors.common.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            padding: AppPadding.all(16),

            child: Column(
              children: [
                AppText(
                  "Ratings & Reviews ($totalReviews)",
                  variant: TextVariant.heading8,
                  weight: TextWeight.bold,
                ),
                AppGap.height(8),
                AppText("Ringkasan", variant: TextVariant.body3),
                AppGap.height(8),

                _buildRatingSummary(summary, averageRating, totalReviews),

                AppGap.height(16),
                AppText(
                  align: TextAlign.left,
                  "Ulasan produk dikelola oleh pihak ketiga untuk memverifikasi keaslian dan kepatuhan terhadap pedoman ulasan.",
                  variant: TextVariant.body3,
                  color: AppColors.light.textSecondary,
                ),
              ],
            ),
          ),
          AppGap.height(20),

          ...reviews.map((review) => _buildReviewCard(review)).toList(),
        ],
      ],
    );
  }

  Widget _buildRatingSummary(Map<int, int> summary, double avg, int total) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final star = 5 - index;
                  final count = summary[star] ?? 0;
                  double percent = total > 0 ? (count / total) : 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        AppText(star.toString(), variant: TextVariant.body3),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        AppGap.width(6),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percent,
                            color: AppColors.light.starYellow,
                            backgroundColor: AppColors.common.grey300,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            AppGap.width(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  avg.toStringAsFixed(1),
                  variant: TextVariant.heading6,
                  weight: TextWeight.bold,
                  color: AppColors.light.primary,
                ),
                AppText(
                  "$total Reviews",
                  variant: TextVariant.body3,
                  color: AppColors.light.textSecondary,
                ),
                AppText(
                  "${(avg / 5 * 100).toStringAsFixed(0)}%",
                  variant: TextVariant.body3,
                  color: AppColors.light.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 🔸 Kartu Review User
  Widget _buildReviewCard(Review review) {
    final formattedDate = DateFormat('dd MMM, yyyy').format(review.date);
    return Container(
      color: AppColors.common.white,
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ Rating Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.light.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    AppText(
                      review.rating.toStringAsFixed(1),
                      color: AppColors.light.primary,
                      variant: TextVariant.body3,
                      weight: TextWeight.bold,
                    ),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                  ],
                ),
              ),
            ],
          ),
          AppGap.height(8),
          AppText(
            review.comment,
            variant: TextVariant.body3,
            align: TextAlign.left,
          ),
          AppGap.height(8),

          // 🖼️ Gambar produk (jika ada)
          if (review.images.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: review.images
                  .map(
                    (img) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        img,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  .toList(),
            ),

          AppGap.height(10),
          AppText(
            "${review.username}   $formattedDate",
            variant: TextVariant.body3,
            color: AppColors.light.textSecondary,
          ),
        ],
      ),
    );
  }
}

Map<int, int> _ratingSummary(List<Review> reviews) {
  final summary = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  for (var r in reviews) {
    final key = r.rating.round().clamp(1, 5);
    summary[key] = (summary[key] ?? 0) + 1;
  }
  return summary;
}
