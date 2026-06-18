import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Simple in-memory wishlist store shared across screens.
///
/// Backend integration note: the backend's Wishlist endpoints
/// (GET /user/wishlist, POST /user/wishlist/toggle) exist in
/// WishlistController but are NOT YET registered in routes/api.php -
/// calling them today returns 404. Once the backend adds those routes,
/// replace the methods below with real API calls (the toggle endpoint
/// returns { message, wishlisted: bool }) and keep this same public
/// interface so the UI doesn't need to change.
class WishlistStore extends ChangeNotifier {
  WishlistStore._internal();
  static final WishlistStore instance = WishlistStore._internal();

  final Set<int> _productIds = {};
  final Map<int, Product> _products = {};

  List<Product> get items => _productIds.map((id) => _products[id]!).toList();

  bool isFavorite(int productId) => _productIds.contains(productId);

  void toggle(Product product) {
    if (_productIds.contains(product.id)) {
      _productIds.remove(product.id);
      _products.remove(product.id);
    } else {
      _productIds.add(product.id);
      _products[product.id] = product;
    }
    notifyListeners();
  }
}
