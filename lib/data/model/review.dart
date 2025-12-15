class Review {
  final double rating;
  final String comment;
  final List<String> images;
  final String username;
  final DateTime date;

  Review({
    required this.rating,
    required this.comment,
    required this.images,
    required this.username,
    required this.date,
  });
}
