import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/order_store.dart';

/// Backend: GET /user/orders/archived, POST /user/orders/{id}/restore,
/// DELETE /user/orders/{id}/force
class ArchivedOrdersScreen extends StatefulWidget {
  const ArchivedOrdersScreen({super.key});

  @override
  State<ArchivedOrdersScreen> createState() => _ArchivedOrdersScreenState();
}

class _ArchivedOrdersScreenState extends State<ArchivedOrdersScreen> {
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

  void _confirmDelete(int orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete permanently?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text('This cannot be undone.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              OrderStore.instance.forceDeleteOrder(orderId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete Forever', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = OrderStore.instance.archivedOrders;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: AppColors.textPrimary,
                ),
                Text('Archived Orders', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
              ]),
            ),
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          width: 88, height: 88,
                          decoration: const BoxDecoration(color: AppColors.cardWhite, shape: BoxShape.circle),
                          child: const Icon(Icons.archive_outlined, size: 36, color: AppColors.textHint),
                        ),
                        const SizedBox(height: 16),
                        const Text('No archived orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ]),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.cardWhite, borderRadius: BorderRadius.circular(16)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Order #${order.id}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(
                              '${order.items.length} item${order.items.length == 1 ? '' : 's'} · \$${order.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                            ),
                            const SizedBox(height: 14),
                            Row(children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => OrderStore.instance.restoreOrder(order.id),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  child: const Text('Restore', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _confirmDelete(order.id),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.error),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  child: const Text('Delete', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.error)),
                                ),
                              ),
                            ]),
                          ]),
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
