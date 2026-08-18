import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/product_variant.dart';

/// Backend integration note:
/// POST /user/cart/add-or-update { variant_id, quantity }
/// GET  /user/cart
/// PUT  /user/cart/{id} { quantity }
/// DELETE /user/cart/{id}
/// DELETE /user/cart/clear
class CartStore extends ChangeNotifier {
  CartStore._internal();
  static final CartStore instance = CartStore._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice => _items.fold(0, (sum, i) => sum + i.subtotal);

  void addItem(Product product, ProductVariant variant, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.matches(product.id, variant.id));
    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, variant: variant, quantity: quantity));
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
