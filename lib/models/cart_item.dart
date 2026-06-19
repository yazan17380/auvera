import 'product.dart';


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
