import 'product.dart';

/// Cart item data model.
/// Mirrors the backend's CartService logic: a cart item is identified by
/// (product_id, size, color) and holds a quantity.
/// NOTE: backend's CartItem fillable currently only lists
/// [user_id, product_id, quantity] while CartService also reads/writes
/// size and color - this model follows the service's intended shape.
class CartItem {
  final Product product;
  final String? size;
  final String? color;
  int quantity;

  CartItem({
    required this.product,
    this.size,
    this.color,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  /// Two cart items are considered the same line if they share product+size+color
  bool matches(int productId, String? size, String? color) {
    return product.id == productId && this.size == size && this.color == color;
  }
}
