class ProductQueryParams {
  final int page;
  final int perPage;
  final String? city;
  final String? search;
  final String? merchantType;
  final String? paymentMethod;

  const ProductQueryParams({
    required this.page,
    this.perPage = 10,
    this.city,
    this.search,
    this.merchantType,
    this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'per_page': perPage,
      if (city != null && city!.isNotEmpty) 'city': city,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (merchantType != null && merchantType!.isNotEmpty)
        'merchant_type': merchantType,
      if (paymentMethod != null && paymentMethod!.isNotEmpty)
        'payment_method': paymentMethod,
    };
  }

  ProductQueryParams copyWith({
    int? page,
    int? perPage,
    String? city,
    String? search,
    String? merchantType,
    String? paymentMethod,
  }) {
    return ProductQueryParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      city: city ?? this.city,
      search: search ?? this.search,
      merchantType: merchantType ?? this.merchantType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  String toString() => toMap().toString();
}
