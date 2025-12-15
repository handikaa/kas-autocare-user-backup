import '../model/review.dart';

final dummyReviews = [
  Review(
    rating: 4.3,
    comment:
        "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.",
    images: [
      "https://picsum.photos/id/21/200/200",
      "https://picsum.photos/id/22/200/200",
    ],
    username: "Keiko Ravensa",
    date: DateTime(2021, 8, 20),
  ),
  Review(
    rating: 5.0,
    comment:
        "Produk sangat bagus! Pengiriman cepat dan kualitas sesuai ekspektasi.",
    images: [],
    username: "Agil Nurdiansah",
    date: DateTime(2021, 8, 22),
  ),
  Review(
    rating: 3.5,
    comment: "Cukup bagus, tapi kemasan agak rusak saat diterima.",
    images: ["https://picsum.photos/id/25/200/200"],
    username: "Rina Putri",
    date: DateTime(2021, 9, 5),
  ),
];
