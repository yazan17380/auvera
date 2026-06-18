import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/review.dart';

/// Reviews section shown on Product Details.
///
/// Backend integration note: ReviewController (store, index) exists but
/// its routes are NOT YET registered in routes/api.php - calling
/// POST /reviews or GET /reviews/{productId} today returns 404.
/// Also note the backend only allows POST /reviews if the user has an
/// order with status == 'delivered' containing this product - the UI
/// should be ready to surface that 403 error message once connected.
class ReviewsSection extends StatefulWidget {
  final int productId;

  const ReviewsSection({super.key, required this.productId});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  late List<Review> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List.from(mockReviewsByProductId[widget.productId] ?? []);
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.fold<int>(0, (sum, r) => sum + r.rating) / _reviews.length;
  }

  Future<void> _openAddReviewSheet() async {
    final result = await showModalBottomSheet<Review>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddReviewSheet(productId: widget.productId),
    );

    if (result != null) {
      setState(() => _reviews.insert(0, result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            GestureDetector(
              onTap: _openAddReviewSheet,
              child: const Text(
                'Write a Review',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No reviews yet. Be the first to share your thoughts.',
              style: TextStyle(fontSize: 13, color: AppColors.textHint),
            ),
          )
        else ...[
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: Color(0xFFE8A23D)),
              const SizedBox(width: 4),
              Text(
                _averageRating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 4),
              Text(
                'based on ${_reviews.length} review${_reviews.length == 1 ? '' : 's'}',
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._reviews.map((review) => _ReviewTile(review: review)),
        ],
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: const Color(0xFFE8A23D),
                  );
                }),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddReviewSheet extends StatefulWidget {
  final int productId;
  const _AddReviewSheet({required this.productId});

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedRating == 0) return;

    // Backend integration note: POST /reviews with
    // { product_id: widget.productId, rating: _selectedRating, comment }
    // Server responds 403 if the user hasn't received a delivered order
    // containing this product - surface that message to the user once wired.
    Navigator.of(context).pop(
      Review(
        id: DateTime.now().millisecondsSinceEpoch,
        userName: 'You',
        productId: widget.productId,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Write a Review',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = starValue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      starValue <= _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 34,
                      color: const Color(0xFFE8A23D),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share your experience with this product...',
                filled: true,
                fillColor: AppColors.cardWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedRating == 0 ? null : _submit,
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
