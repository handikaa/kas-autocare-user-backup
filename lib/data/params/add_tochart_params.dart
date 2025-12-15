import 'dart:convert';

class AddChartParams {
  final int? branchId;
  final int? bussinesId;

  final int? branchProductNewsId;
  final int? variantId;
  final int? variantSizeId;
  final int? userId;
  final int? qty;

  AddChartParams({
    this.branchId,
    this.bussinesId,

    this.branchProductNewsId,
    this.variantId,
    this.variantSizeId,
    this.userId,
    this.qty,
  });

  AddChartParams copyWith({
    int? branchId,
    int? bussinesId,
    int? businessUnitId,
    int? branchProductNewsId,
    int? variantId,
    int? variantSizeId,
    int? userId,
    int? qty,
  }) => AddChartParams(
    branchId: branchId ?? this.branchId,
    bussinesId: bussinesId ?? this.bussinesId,

    branchProductNewsId: branchProductNewsId ?? this.branchProductNewsId,
    variantId: variantId ?? this.variantId,
    variantSizeId: variantSizeId ?? this.variantSizeId,
    userId: userId ?? this.userId,
    qty: qty ?? this.qty,
  );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "branch_id": branchId,
    "bussines_id": bussinesId,

    "branch_product_news_id": branchProductNewsId,
    "variant_product_news_id": variantId,
    "variant_product_size_news_id": variantSizeId,
    "user_id": userId,
    "qty": qty,
  };
}
