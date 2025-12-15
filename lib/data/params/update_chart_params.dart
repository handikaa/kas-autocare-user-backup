import 'dart:convert';

class UpdateChartParams {
  final int qty;
  final int branchProductNewsId;
  final int variantProductNewsId;
  final int variantProductSizeNewsId;

  UpdateChartParams({
    required this.qty,
    required this.branchProductNewsId,
    required this.variantProductNewsId,
    required this.variantProductSizeNewsId,
  });

  UpdateChartParams copyWith({
    int? qty,
    int? branchProductNewsId,
    int? variantProductNewsId,
    int? variantProductSizeNewsId,
  }) => UpdateChartParams(
    qty: qty ?? this.qty,
    branchProductNewsId: branchProductNewsId ?? this.branchProductNewsId,
    variantProductNewsId: variantProductNewsId ?? this.variantProductNewsId,
    variantProductSizeNewsId:
        variantProductSizeNewsId ?? this.variantProductSizeNewsId,
  );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "qty": qty,
    "branch_product_news_id": branchProductNewsId,
    if (variantProductNewsId != 0)
      "variant_product_news_id": variantProductNewsId,
    if (variantProductSizeNewsId != 0)
      "variant_product_size_news_id": variantProductSizeNewsId,
  };
}
