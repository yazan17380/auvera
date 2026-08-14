import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/order.dart';
import '../services/order_store.dart';
import 'order_details_screen.dart';
import 'archived_orders_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String _selectedStatus = 'all';

  static const List<Map<String, String>> _tabs = [
    {'value': 'all', 'label': 'All'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'processing', 'label': 'Processing'},
    {'value': 'delivered', 'label': 'Delivered'},
    {'value': 'canceled', 'label': 'Canceled'},
  ];

  @override
  void initState() {
    super.initState();
    OrderStore.instance.addListener(_onChanged);
  }

  @override
  void dispose() {
    OrderStore.instance.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  List<Order> get _filtered {
    final orders = OrderStore.instance.orders;
    if (_selectedStatus == 'all') return orders;
    return orders.where((o) => o.status == _selectedStatus).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return const Color(0xFFE8A23D);
      case 'processing': return AppColors.primary;
      case 'delivered': return AppColors.success;
      case 'canceled': return AppColors.error;
      default: return AppColors.textHint;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending': return 'Pending';
      case 'processing': return 'Processing';
      case 'delivered': return 'Delivered';
      case 'canceled': return 'Canceled';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filtered;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Orders', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ArchivedOrdersScreen()),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.archive_outlined, size: 16, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('Archived', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  final isSelected = _selectedStatus == tab['value'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStatus = tab['value']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(
                        tab['label']!,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(color: AppColors.cardWhite, shape: BoxShape.circle),
                            child: const Icon(Icons.receipt_long_outlined, size: 36, color: AppColors.textHint),
                          ),
                          const SizedBox(height: 16),
                          Text('No orders here', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: order.id)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order #${order.id}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor(order.status).withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _statusLabel(order.status),
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor(order.status)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${order.items.length} item${order.items.length == 1 ? '' : 's'} · ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\$${order.totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                    const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textHint),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
