import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/wishlist_store.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';


/// Showing mock data filtered by categoryName for now.
class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    WishlistStore.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    WishlistStore.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  /// Filter mock products by category name (mock only - real version will
  /// fetch GET /user/categories/{id}/products once route is registered)
  List<Product> get _products {
    return mockProducts
        .where((p) => p.categoryName.toLowerCase() == widget.category.name.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _products;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: AppColors.textPrimary,
                  ),
                  Expanded(
                    child: Text(
                      widget.category.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
                    ),
                  ),
                  Text(
                    '${products.isNotEmpty ? products.length : widget.category.productsCount} items',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: AppColors.cardWhite,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(widget.category.icon, size: 36, color: AppColors.textHint),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products in ${widget.category.name}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Check back later for new arrivals.',
                            style: TextStyle(fontSize: 12.5, color: AppColors.textHint),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          isFavorite: WishlistStore.instance.isFavorite(product.id),
                          onFavoriteTap: () => WishlistStore.instance.toggle(product),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
