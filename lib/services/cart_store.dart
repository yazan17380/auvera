import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Simple in-memory cart store shared across screens.
///
/// Backend integration note: the backend's Cart endpoints
/// (GET/POST /user/cart, PUT /user/cart/{id}, DELETE /user/cart/{id},
/// DELETE /user/cart) exist in CartController but are NOT YET registered
/// in routes/api.php - calling them today returns 404. Once the backend
/// adds those routes, replace the methods below with real API calls and
/// keep this same public interface so the UI doesn't need to change.
class CartStore extends ChangeNotifier {
  CartStore._internal();
  static final CartStore instance = CartStore._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  void addItem(Product product, {String? size, String? color, int quantity = 1}) {
    final existingIndex = _items.indexWhere((i) => i.matches(product.id, size, color));
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, size: size, color: color, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      removeItem(item);
      return;
    }
    final index = _items.indexOf(item);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
