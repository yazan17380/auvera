import 'product_variant.dart';


class Product {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> images;
  final String description;
  final double price;
  final double rating;
  final int reviewsCount;
  final String categoryName;
  final bool isBestSeller;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.images = const [],
    this.description = '',
    required this.price,
    this.rating = 0,
    this.reviewsCount = 0,
    required this.categoryName,
    this.isBestSeller = false,
    this.variants = const [],
  });

  List<String> get gallery => images.isNotEmpty ? images : [imageUrl];

  String get displayDescription => description.isNotEmpty
      ? description
      : 'A carefully selected piece from our $categoryName collection, '
          'combining quality materials with a comfortable, modern fit.';

  
  List<String> get availableColors {
    final colors = variants
        .where((v) => v.color != null && v.inStock)
        .map((v) => v.color!)
        .toSet()
        .toList();
    return colors;
  }

  
  List<String> availableSizes({String? forColor}) {
    return variants
        .where((v) =>
            v.size != null &&
            v.inStock &&
            (forColor == null || v.color == forColor))
        .map((v) => v.size!)
        .toSet()
        .toList();
  }

  
  ProductVariant? findVariant({required String color, required String size}) {
    try {
      return variants.firstWhere((v) => v.color == color && v.size == size);
    } catch (_) {
      return null;
    }
  }
}

/// Mock
final List<Product> mockProducts = [
  Product(
    id: 1,
    name: 'Beautiful Blazer',
    imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
    images: [
      'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600',
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600',
    ],
    description: 'A timeless blazer crafted from premium fabric, designed for both comfort and elegance.',
    price: 54,
    rating: 4.8,
    reviewsCount: 120,
    categoryName: 'Jackets',
    isBestSeller: true,
    variants: const [
      ProductVariant(id: 101, color: 'Black', size: 'S', stock: 5),
      ProductVariant(id: 102, color: 'Black', size: 'M', stock: 3),
      ProductVariant(id: 103, color: 'Brown', size: 'S', stock: 2),
      ProductVariant(id: 104, color: 'Brown', size: 'M', stock: 0),
    ],
  ),
  Product(
    id: 2,
    name: 'Colored Chemise',
    imageUrl: 'https://images.unsplash.com/photo-1602810316693-3667c854239a?w=400',
    price: 38,
    rating: 4.5,
    reviewsCount: 86,
    categoryName: 'Shirts',
    isBestSeller: true,
    variants: const [
      ProductVariant(id: 201, color: 'White', size: 'M', stock: 10),
      ProductVariant(id: 202, color: 'White', size: 'L', stock: 7),
      ProductVariant(id: 203, color: 'Navy', size: 'M', stock: 4),
    ],
  ),
  Product(
    id: 3,
    name: 'Summer Dress',
    imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400',
    price: 49,
    rating: 4.7,
    reviewsCount: 203,
    categoryName: 'Dresses',
    variants: const [
      ProductVariant(id: 301, color: 'Pink', size: 'S', stock: 6),
      ProductVariant(id: 302, color: 'Pink', size: 'M', stock: 3),
      ProductVariant(id: 303, color: 'Beige', size: 'S', stock: 2),
    ],
  ),
  Product(
    id: 4,
    name: 'Casual Sneakers',
    imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
    price: 65,
    rating: 4.6,
    reviewsCount: 154,
    categoryName: 'Shoes',
    isBestSeller: true,
    variants: const [
      ProductVariant(id: 401, color: 'White', size: 'M', stock: 8),
      ProductVariant(id: 402, color: 'White', size: 'L', stock: 5),
      ProductVariant(id: 403, color: 'Black', size: 'M', stock: 3),
    ],
  ),
  Product(
    id: 5,
    name: 'Knit Sweater',
    imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
    price: 42,
    rating: 4.4,
    reviewsCount: 67,
    categoryName: 'Sweaters',
    variants: const [
      ProductVariant(id: 501, color: 'Beige', size: 'M', stock: 4),
      ProductVariant(id: 502, color: 'Beige', size: 'L', stock: 2),
    ],
  ),
  Product(
    id: 6,
    name: 'Leather Handbag',
    imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    price: 89,
    rating: 4.9,
    reviewsCount: 312,
    categoryName: 'Bags',
    isBestSeller: true,
    variants: const [
      ProductVariant(id: 601, color: 'Brown', size: 'M', stock: 7),
      ProductVariant(id: 602, color: 'Black', size: 'M', stock: 5),
    ],
  ),
  Product(
    id: 7,
    name: 'Denim Jacket',
    imageUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=400',
    price: 58,
    rating: 4.6,
    reviewsCount: 98,
    categoryName: 'Jackets',
    variants: const [
      ProductVariant(id: 701, color: 'Navy', size: 'M', stock: 6),
      ProductVariant(id: 702, color: 'Navy', size: 'L', stock: 3),
    ],
  ),
  Product(
    id: 8,
    name: 'Linen Trousers',
    imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
    price: 46,
    rating: 4.3,
    reviewsCount: 54,
    categoryName: 'Pants',
    variants: const [
      ProductVariant(id: 801, color: 'Beige', size: 'M', stock: 5),
      ProductVariant(id: 802, color: 'Beige', size: 'L', stock: 2),
      ProductVariant(id: 803, color: 'White', size: 'M', stock: 4),
    ],
  ),
];

List<Product> get mockBestSellers =>
    mockProducts.where((p) => p.isBestSeller).toList();

List<Product> get mockSaleProducts => mockProducts.take(4).toList();

List<Product> get mockRecommendedProducts => mockProducts;
