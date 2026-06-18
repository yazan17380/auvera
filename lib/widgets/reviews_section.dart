import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/review.dart';

/// Reviews section shown on Product Details.
///
/// Backend integration note: ReviewController->store() uses
/// updateOrCreate(['user_id', 'product_id'], [...]) - meaning the backend
/// already enforces "one review per user per product": submitting again
/// updates the existing row instead of creating a duplicate. This UI
/// mirrors that behavior locally: if the current user already has a
/// review for this product, the action becomes "Edit Your Review" and the
/// sheet opens pre-filled, replacing the old entry instead of inserting
/// a new one.
///
/// Routes are NOT YET registered in routes/api.php - calling POST /reviews
/// or GET /reviews/{productId} today returns 404. Also note the backend
/// only allows POST /reviews if the user has an order with
/// status == 'delivered' containing this product - the UI should be ready
/// to surface that 403 error message once connected.
class ReviewsSection extends StatefulWidget {
  final int productId;

  const ReviewsSection({super.key, required this.productId});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  late List<Review> _reviews;

  // Mock current user identity (no real auth/session wired yet).
  // Once connected, compare by the logged-in user's id instead of name.
  static const String _currentUserName = 'You';

  @override
  void initState() {
    super.initState();
    _reviews = List.from(mockReviewsByProductId[widget.productId] ?? []);
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.fold<int>(0, (sum, r) => sum + r.rating) / _reviews.length;
  }

  Review? get _myReview =>
      _reviews.where((r) => r.userName == _currentUserName).isEmpty
          ? null
          : _reviews.firstWhere((r) => r.userName == _currentUserName);

  Future<void> _openReviewSheet() async {
    final existingReview = _myReview;

    final result = await showModalBottomSheet<Review>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddReviewSheet(
        productId: widget.productId,
        existingReview: existingReview,
      ),
    );

    if (result == null) return;

    setState(() {
      if (existingReview != null) {
        // Backend behavior mirrored: replace, don't duplicate.
        final index = _reviews.indexOf(existingReview);
        _reviews[index] = result;
      } else {
        _reviews.insert(0, result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myReview = _myReview;

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
              onTap: _openReviewSheet,
              child: Text(
                myReview != null ? 'Edit Your Review' : 'Write a Review',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary),
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
          ..._reviews.map((review) => _ReviewTile(
                review: review,
                isMine: review.userName == _currentUserName,
              )),
        ],
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Review review;
  final bool isMine;
  const _ReviewTile({required this.review, this.isMine = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: isMine ? Border.all(color: AppColors.primary.withOpacity(0.4)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    review.userName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'You',
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ],
                ],
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
  final Review? existingReview;

  const _AddReviewSheet({required this.productId, this.existingReview});

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  late int _selectedRating;
  late final TextEditingController _commentController;

  bool get _isEditing => widget.existingReview != null;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.existingReview?.rating ?? 0;
    _commentController = TextEditingController(text: widget.existingReview?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedRating == 0) return;

    // Backend integration note: POST /reviews with
    // { product_id: widget.productId, rating: _selectedRating, comment }
    // The backend uses updateOrCreate(['user_id','product_id'], [...]) so
    // sending this again for the same product updates the existing review
    // server-side - no duplicate handling needed on that end.
    // Server responds 403 if the user hasn't received a delivered order
    // containing this product - surface that message to the user once wired.
    Navigator.of(context).pop(
      Review(
        id: widget.existingReview?.id ?? DateTime.now().millisecondsSinceEpoch,
        userName: 'You',
        productId: widget.productId,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
        createdAt: widget.existingReview?.createdAt ?? DateTime.now(),
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
            Text(
              _isEditing ? 'Edit Your Review' : 'Write a Review',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
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
              child: Text(_isEditing ? 'Update Review' : 'Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
