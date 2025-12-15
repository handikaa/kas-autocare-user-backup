class Product {
  final String name;
  final int price;
  final String description;
  final bool inStock;
  final int stock;
  final String location;
  final double rating;
  final int totalReviews;
  final List<ProductVariant> variants;
  final List<String> tags;
  final List<String> images;
  final List<ProductReview> reviews;
  final Map<String, String>? selectedVariants;
  final int qty;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.inStock,
    required this.stock,
    required this.location,
    required this.rating,
    required this.totalReviews,
    required this.variants,
    required this.tags,
    required this.images,
    required this.reviews,
    this.selectedVariants,
    this.qty = 1,
  });

  Product copyWith({
    String? name,
    int? price,
    String? description,
    bool? inStock,
    int? stock,
    String? location,
    double? rating,
    int? totalReviews,
    List<ProductVariant>? variants,
    List<String>? tags,
    List<String>? images,
    List<ProductReview>? reviews,
    Map<String, String>? selectedVariants, // ✅ ubah ke Map<String, String>
    int? qty,
  }) {
    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      inStock: inStock ?? this.inStock,
      stock: stock ?? this.stock,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      variants: variants ?? this.variants,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      reviews: reviews ?? this.reviews,
      selectedVariants:
          selectedVariants ?? this.selectedVariants, // ✅ sekarang cocok
      qty: qty ?? this.qty,
    );
  }
}

class ProductVariant {
  final String type;
  final List<String> options;

  ProductVariant({required this.type, required this.options});
}

class ProductReview {
  final double rating;
  final String reviewer;
  final String review;
  final String date;
  final List<String>? photos;

  ProductReview({
    required this.rating,
    required this.reviewer,
    required this.review,
    required this.date,
    this.photos,
  });
}
