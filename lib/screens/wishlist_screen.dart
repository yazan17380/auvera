import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/wishlist_store.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

/// Backend integration note: Wishlist endpoints (WishlistController: index,
/// toggle) exist but are NOT YET registered in routes/api.php. This screen
/// reads from WishlistStore (local, in-memory) for now. Once GET
/// /user/wishlist and POST /user/wishlist/toggle routes are added, swap
/// WishlistStore's internals for real API calls.
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
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

  @override
  Widget build(BuildContext context) {
    final items = WishlistStore.instance.items;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: const BoxDecoration(color: AppColors.cardWhite, shape: BoxShape.circle),
                              child: const Icon(Icons.favorite_border_rounded, size: 40, color: AppColors.textHint),
                            ),
                            const SizedBox(height: 20),
                            Text('No favorites yet', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 17)),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the heart icon on any product to save it here.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final product = items[index];
                        return ProductCard(
                          product: product,
                          isFavorite: true,
                          onFavoriteTap: () => WishlistStore.instance.toggle(product),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
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
