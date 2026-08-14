import 'package:flutter/foundation.dart';
import '../models/order.dart';

class OrderStore extends ChangeNotifier {
  OrderStore._internal();
  static final OrderStore instance = OrderStore._internal();

  final List<Order> _orders = List.from(mockOrders);
  final List<Order> _archivedOrders = List.from(mockArchivedOrders);

  List<Order> get orders => List.unmodifiable(_orders);
  List<Order> get archivedOrders => List.unmodifiable(_archivedOrders);

  Order? getById(int id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  void updateOrder(int id, {required String address, String? notes, required String paymentMethod}) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) return;
    final old = _orders[index];
    _orders[index] = Order(
      id: old.id,
      totalPrice: old.totalPrice,
      status: old.status,
      paymentMethod: paymentMethod,
      address: address,
      notes: notes,
      createdAt: old.createdAt,
      items: old.items,
    );
    notifyListeners();
  }

  void cancelOrder(int id) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) return;
    final old = _orders[index];
    if (!old.canCancel) return;
    _orders[index] = Order(
      id: old.id,
      totalPrice: old.totalPrice,
      status: 'canceled',
      paymentMethod: old.paymentMethod,
      address: old.address,
      notes: old.notes,
      createdAt: old.createdAt,
      items: old.items,
    );
    notifyListeners();
  }

  void archiveOrder(int id) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index == -1) return;
    final order = _orders.removeAt(index);
    _archivedOrders.insert(0, order);
    notifyListeners();
  }

  void restoreOrder(int id) {
    final index = _archivedOrders.indexWhere((o) => o.id == id);
    if (index == -1) return;
    final order = _archivedOrders.removeAt(index);
    _orders.insert(0, order);
    notifyListeners();
  }

  void forceDeleteOrder(int id) {
    _archivedOrders.removeWhere((o) => o.id == id);
    notifyListeners();
  }
}
