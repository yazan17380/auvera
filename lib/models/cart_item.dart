import 'product.dart';
import 'product_variant.dart';


class CartItem {
  final Product product;
  final ProductVariant variant;
  int quantity;

  CartItem({
    required this.product,
    required this.variant,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  bool matches(int productId, int variantId) {
    return product.id == productId && variant.id == variantId;
  }
}
