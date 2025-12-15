import '../model/product_dummy_model.dart';

final dummyProduct = Product(
  name: "Otogard Gold Line",
  price: 45000,
  description: """
Sampo khusus mobil yang diformulasikan untuk membersihkan kotoran tanpa merusak cat mobil.
Tersedia dalam berbagai jenis, seperti sampo salju yang menghasilkan busa tebal untuk membantu mengangkat debu dan kotoran dari permukaan, sehingga permukaan mobil tetap mengilap dan terlindungi.
""",
  inStock: true,
  stock: 125,
  location: "RPN Jakarta",
  rating: 3.7,
  totalReviews: 273,
  variants: [
    ProductVariant(type: "Size", options: ["1000g", "500g", "250g"]),
    ProductVariant(type: "Color", options: ["Gold", "Black", "Silver"]),
  ],
  tags: ["vegan", "organic", "SLS & Paraben free"],
  images: [
    "https://picsum.photos/500/300",
    "https://picsum.photos/500/301",
    "https://picsum.photos/500/302",
  ],
  reviews: [
    ProductReview(
      rating: 4.9,
      reviewer: "Keiko Ravelans",
      review:
          "Amet mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
      date: "20 Aug, 2021",
      photos: [
        "https://picsum.photos/100/100",
        "https://picsum.photos/101/100",
      ],
    ),
    ProductReview(
      rating: 4.8,
      reviewer: "Dika Djati",
      review: "Produk sangat bagus, busanya banyak dan mobil jadi kinclong!",
      date: "02 Oct, 2023",
    ),
    ProductReview(
      rating: 4.7,
      reviewer: "Andra Putra",
      review: "Harga terjangkau, kualitas melebihi ekspektasi.",
      date: "10 Jan, 2024",
    ),
  ],
);
