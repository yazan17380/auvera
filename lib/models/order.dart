class OrderItemEntry {
  final int productId;
  final String productName;
  final String productImageUrl;
  final int? variantId;
  final int quantity;
  final double price;

  const OrderItemEntry({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    this.variantId,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;
}

class Order {
  final int id;
  final double totalPrice;
  final String status; // pending, processing, delivered, canceled
  final String paymentMethod; // 'cash' or 'card'
  final String address;
  final String? notes;
  final DateTime createdAt;
  final List<OrderItemEntry> items;

  const Order({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.address,
    this.notes,
    required this.createdAt,
    this.items = const [],
  });

  bool get canEdit => status == 'pending';
  bool get canCancel => status == 'pending' || status == 'processing';
}

final List<Order> mockOrders = [
  Order(
    id: 101,
    totalPrice: 143,
    status: 'pending',
    paymentMethod: 'cash',
    address: 'Damascus, Syria',
    notes: 'Please deliver in the morning',
    createdAt: DateTime(2026, 7, 10),
    items: [
      const OrderItemEntry(
        productId: 1,
        productName: 'Beautiful Blazer',
        productImageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=200',
        quantity: 1,
        price: 54,
      ),
      const OrderItemEntry(
        productId: 6,
        productName: 'Leather Handbag',
        productImageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=200',
        quantity: 1,
        price: 89,
      ),
    ],
  ),
  Order(
    id: 98,
    totalPrice: 65,
    status: 'processing',
    paymentMethod: 'card',
    address: 'Damascus, Syria',
    createdAt: DateTime(2026, 6, 28),
    items: [
      const OrderItemEntry(
        productId: 4,
        productName: 'Casual Sneakers',
        productImageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=200',
        quantity: 1,
        price: 65,
      ),
    ],
  ),
  Order(
    id: 92,
    totalPrice: 96,
    status: 'delivered',
    paymentMethod: 'cash',
    address: 'Damascus, Syria',
    createdAt: DateTime(2026, 6, 5),
    items: [
      const OrderItemEntry(
        productId: 2,
        productName: 'Colored Chemise',
        productImageUrl: 'https://images.unsplash.com/photo-1602810316693-3667c854239a?w=200',
        quantity: 2,
        price: 38,
      ),
      const OrderItemEntry(
        productId: 5,
        productName: 'Knit Sweater',
        productImageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=200',
        quantity: 1,
        price: 20,
      ),
    ],
  ),
  Order(
    id: 87,
    totalPrice: 49,
    status: 'canceled',
    paymentMethod: 'cash',
    address: 'Damascus, Syria',
    createdAt: DateTime(2026, 5, 18),
    items: [
      const OrderItemEntry(
        productId: 3,
        productName: 'Summer Dress',
        productImageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=200',
        quantity: 1,
        price: 49,
      ),
    ],
  ),
];

final List<Order> mockArchivedOrders = [
  Order(
    id: 80,
    totalPrice: 42,
    status: 'canceled',
    paymentMethod: 'cash',
    address: 'Damascus, Syria',
    createdAt: DateTime(2026, 4, 10),
    items: [
      const OrderItemEntry(
        productId: 5,
        productName: 'Knit Sweater',
        productImageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=200',
        quantity: 1,
        price: 42,
      ),
    ],
  ),
];
