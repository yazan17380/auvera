
class Review {
  final int id;
  final String userName;
  final int productId;
  final int rating; // 1-5, integer (backend casts rating as integer)
  final String? comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.userName,
    required this.productId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}


final Map<int, List<Review>> mockReviewsByProductId = {
  1: [
    Review(
      id: 1,
      userName: 'Sarah M.',
      productId: 1,
      rating: 5,
      comment: 'Excellent quality, fits perfectly and looks even better in person.',
      createdAt: DateTime(2026, 5, 12),
    ),
    Review(
      id: 2,
      userName: 'Ahmad K.',
      productId: 1,
      rating: 4,
      comment: 'Great blazer, slightly large on the shoulders for me.',
      createdAt: DateTime(2026, 5, 2),
    ),
  ],
  6: [
    Review(
      id: 3,
      userName: 'Lina T.',
      productId: 6,
      rating: 5,
      comment: 'Beautiful bag, the leather feels premium.',
      createdAt: DateTime(2026, 4, 20),
    ),
  ],
};
