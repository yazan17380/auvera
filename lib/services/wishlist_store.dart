import 'package:flutter/foundation.dart';
import '../models/product.dart';



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
