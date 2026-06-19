
class Product {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> images;
  final String description;
  final double price;
  final double? oldPrice; // for discounted items, null if no discount
  final double rating;
  final int reviewsCount;
  final String categoryName;
  final bool isBestSeller;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.images = const [],
    this.description = '',
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    required this.categoryName,
    this.isBestSeller = false,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  
  List<String> get gallery => images.isNotEmpty ? images : [imageUrl];

  
  String get displayDescription => description.isNotEmpty
      ? description
      : 'A carefully selected piece from our $categoryName collection, '
          'combining quality materials with a comfortable, modern fit.';
}

// (no backend connection yet)

final List<Product> mockProducts = [
  const Product(
    id: 1,
    name: 'Beautiful Blazer',
    imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
    images: [
      'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600',
      'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600',
      'https://images.unsplash.com/photo-1551803091-e20673f15770?w=600',
    ],
    description:
        'A timeless blazer crafted from premium fabric, designed for both comfort and elegance. Perfect for office wear or evening outings, featuring a tailored fit and classic button details.',
    price: 54,
    oldPrice: 70,
    rating: 4.8,
    reviewsCount: 120,
    categoryName: 'Jackets',
    isBestSeller: true,
  ),
  const Product(
    id: 2,
    name: 'Colored Chemise',
    imageUrl: 'https://images.unsplash.com/photo-1602810316693-3667c854239a?w=400',
    price: 38,
    rating: 4.5,
    reviewsCount: 86,
    categoryName: 'Shirts',
    isBestSeller: true,
  ),
  const Product(
    id: 3,
    name: 'Summer Dress',
    imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400',
    price: 49,
    oldPrice: 65,
    rating: 4.7,
    reviewsCount: 203,
    categoryName: 'Dresses',
  ),
  const Product(
    id: 4,
    name: 'Casual Sneakers',
    imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400',
    price: 65,
    rating: 4.6,
    reviewsCount: 154,
    categoryName: 'Shoes',
    isBestSeller: true,
  ),
  const Product(
    id: 5,
    name: 'Knit Sweater',
    imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400',
    price: 42,
    rating: 4.4,
    reviewsCount: 67,
    categoryName: 'Sweaters',
  ),
  const Product(
    id: 6,
    name: 'Leather Handbag',
    imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    price: 89,
    oldPrice: 110,
    rating: 4.9,
    reviewsCount: 312,
    categoryName: 'Bags',
    isBestSeller: true,
  ),
  const Product(
    id: 7,
    name: 'Denim Jacket',
    imageUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=400',
    price: 58,
    oldPrice: 75,
    rating: 4.6,
    reviewsCount: 98,
    categoryName: 'Jackets',
  ),
  const Product(
    id: 8,
    name: 'Linen Trousers',
    imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400',
    price: 46,
    oldPrice: 60,
    rating: 4.3,
    reviewsCount: 54,
    categoryName: 'Pants',
  ),
];

List<Product> get mockBestSellers =>
    mockProducts.where((p) => p.isBestSeller).toList();

List<Product> get mockSaleProducts =>
    mockProducts.where((p) => p.hasDiscount).toList();

List<Product> get mockRecommendedProducts => mockProducts;
