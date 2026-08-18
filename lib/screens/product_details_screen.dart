import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../models/product_variant.dart';
import '../models/review.dart';
import '../services/cart_store.dart';
import '../services/wishlist_store.dart';
import '../widgets/reviews_section.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _galleryController = PageController();
  int _currentImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  bool _showSelectionError = false;

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  /// The resolved variant based on selected color + size
  ProductVariant? get _selectedVariant {
    if (_selectedColor == null || _selectedSize == null) return null;
    return widget.product.findVariant(color: _selectedColor!, size: _selectedSize!);
  }

  List<String> get _availableColors => widget.product.availableColors;

  List<String> get _availableSizes =>
      widget.product.availableSizes(forColor: _selectedColor);

  void _handleAddToCart() {
    if (_selectedColor == null || _selectedSize == null) {
      setState(() => _showSelectionError = true);
      return;
    }

    final variant = _selectedVariant;
    if (variant == null) {
      setState(() => _showSelectionError = true);
      return;
    }

    if (!variant.inStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected variant is out of stock')),
      );
      return;
    }

    setState(() => _showSelectionError = false);

    // Backend integration note:
    // POST /user/cart/add-or-update { variant_id: variant.id, quantity: 1 }
    CartStore.instance.addItem(widget.product, variant);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isFav = WishlistStore.instance.isFavorite(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Gallery
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: PageView.builder(
                        controller: _galleryController,
                        itemCount: product.gallery.length,
                        onPageChanged: (i) => setState(() => _currentImageIndex = i),
                        itemBuilder: (context, index) => Image.network(
                          product.gallery[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.cardWhite,
                            child: const Icon(Icons.image_not_supported_outlined,
                                color: AppColors.textHint, size: 40),
                          ),
                        ),
                      ),
                    ),
                    if (product.gallery.length > 1)
                      Positioned(
                        bottom: 16, left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(product.gallery.length, (i) =>
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentImageIndex == i ? 18 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentImageIndex == i
                                    ? AppColors.primary
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _RoundBtn(icon: Icons.arrow_back_ios_new,
                                onTap: () => Navigator.of(context).pop()),
                            _RoundBtn(
                              icon: isFav ? Icons.favorite : Icons.favorite_border,
                              iconColor: isFav ? AppColors.primary : AppColors.textPrimary,
                              onTap: () => setState(() => WishlistStore.instance.toggle(product)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.categoryName,
                                    style: const TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(product.name,
                                    style: Theme.of(context).textTheme.headlineMedium
                                        ?.copyWith(fontSize: 20)),
                              ],
                            )),
                            Text('\$${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Row(children: [
                          const Icon(Icons.star_rounded, size: 17, color: Color(0xFFE8A23D)),
                          const SizedBox(width: 4),
                          Text(product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 13,
                                  fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          const SizedBox(width: 4),
                          Text('(${product.reviewsCount} reviews)',
                              style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                        ]),

                        const SizedBox(height: 20),
                        const Text('Description', style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Text(product.displayDescription,
                            style: const TextStyle(fontSize: 13,
                                color: AppColors.textSecondary, height: 1.6)),

                        // Color selection
                        if (_availableColors.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text('Color', style: TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10, runSpacing: 10,
                            children: _availableColors.map((color) {
                              final isSelected = _selectedColor == color;
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _selectedColor = color;
                                  _selectedSize = null;
                                  _showSelectionError = false;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.cardWhite,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.border),
                                  ),
                                  child: Text(color, style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : AppColors.textPrimary)),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // Size selection
                        if (_availableSizes.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text('Size', style: TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 12),
                          Row(
                            children: _availableSizes.map((size) {
                              final isSelected = _selectedSize == size;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedSize = size;
                                    _showSelectionError = false;
                                  }),
                                  child: Container(
                                    width: 46, height: 46,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : AppColors.cardWhite,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isSelected ? AppColors.primary : AppColors.border),
                                    ),
                                    child: Text(size, style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppColors.textPrimary)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // Out of stock warning
                        if (_selectedVariant != null && !_selectedVariant!.inStock)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('This combination is out of stock',
                                style: TextStyle(fontSize: 12.5,
                                    color: AppColors.error, fontWeight: FontWeight.w500)),
                          ),

                        // Selection error
                        if (_showSelectionError)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text('Please select a color and size',
                                style: TextStyle(fontSize: 12.5,
                                    color: AppColors.error, fontWeight: FontWeight.w500)),
                          ),

                        const SizedBox(height: 30),
                        ReviewsSection(productId: product.id),
                        const SizedBox(height: 90),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Add to Cart button
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  boxShadow: [BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 16, offset: const Offset(0, -4))],
                ),
                child: ElevatedButton(
                  onPressed: _handleAddToCart,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Add to Cart'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  const _RoundBtn({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}
