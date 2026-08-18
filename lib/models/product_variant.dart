

class ProductVariant {
  final int id;
  final String? color;
  final String? size;
  final int stock;

  const ProductVariant({
    required this.id,
    this.color,
    this.size,
    required this.stock,
  });

  bool get inStock => stock > 0;

  @override
  String toString() {
    final parts = [if (color != null) color!, if (size != null) size!];
    return parts.join(' / ');
  }
}
