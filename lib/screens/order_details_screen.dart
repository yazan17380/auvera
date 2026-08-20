import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/order.dart';
import '../services/order_store.dart';
import 'edit_order_screen.dart';
import 'order_chat_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
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

  Color _statusColor(String s) {
    switch (s) {
      case 'pending':          return const Color(0xFFE8A23D);
      case 'assigned':         return AppColors.primary;
      case 'waiting_delivery':  return const Color(0xFF2196F3);
      case 'waiting_stock':    return const Color(0xFF9C27B0);
      case 'on_the_way':       return const Color(0xFF2196F3);
      case 'delivered':        return AppColors.success;
      case 'canceled':         return AppColors.error;
      case 'returned':         return AppColors.error;
      case 'accepted':         return AppColors.success;
      case 'rejected':         return AppColors.error;
      default:                  return AppColors.textHint;
    }
  }

  String _statusLabelText(String status) {
    switch (status) {
      case 'pending':          return 'Pending';
      case 'assigned':         return 'Assigned';
      case 'waiting_delivery':  return 'Waiting Delivery';
      case 'waiting_stock':    return 'Waiting Stock';
      case 'on_the_way':       return 'On The Way';
      case 'delivered':        return 'Delivered';
      case 'canceled':         return 'Canceled';
      case 'returned':         return 'Returned';
      case 'accepted':         return 'Accepted';
      case 'rejected':         return 'Rejected';
      default:                  return status;
    }
  }

  void _confirmCancel(Order order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Cancel this order?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text('This action cannot be undone.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Order', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              OrderStore.instance.cancelOrder(order.id);
              Navigator.of(context).pop();
            },
            child: const Text('Cancel Order',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmArchive(Order order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Archive this order?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text('You can restore it later from Archived Orders.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              OrderStore.instance.archiveOrder(order.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Archive',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmRefund(Order order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Request Refund?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text(
            'We will review your refund request and get back to you shortly.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              // Backend integration note:
              // POST /user/orders/{id}/refund (no body required)
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refund request submitted successfully')),
              );
            },
            child: const Text('Request Refund',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = OrderStore.instance.getById(widget.orderId);

    if (order == null) {
      return Scaffold(
        body: SafeArea(child: Column(children: [
          Row(children: [
            IconButton(onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 18)),
          ]),
          const Expanded(child: Center(child: Text('Order not found'))),
        ])),
      );
    }

    // Chat only available when status is 'accepted' (delivery picked up)
    final bool canChat = order.status == 'accepted';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      color: AppColors.textPrimary,
                    ),
                    Text('Order #${order.id}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                  ]),
                  Row(children: [
                    if (canChat)
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => OrderChatScreen(orderId: order.id)),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline_rounded,
                            size: 20, color: AppColors.primary),
                      ),
                    if (order.canEdit)
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => EditOrderScreen(orderId: order.id)),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                      ),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(order.status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _statusLabelText(order.status),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                            color: _statusColor(order.status)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                  ]),

                  const SizedBox(height: 22),
                  const Text('Items', style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),

                  ...order.items.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(item.productImageUrl,
                            width: 54, height: 54, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 54, height: 54,
                                color: AppColors.background,
                                child: const Icon(Icons.image_not_supported_outlined,
                                    size: 18, color: AppColors.textHint))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.productName, style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        Text('Qty ${item.quantity} · \$${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.textHint)),
                      ])),
                      Text('\$${item.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ]),
                  )),

                  const SizedBox(height: 16),
                  const Text('Address', style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(order.address, style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),

                  if (order.notes != null && order.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Notes', style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    Text(order.notes!, style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                  ],

                  const SizedBox(height: 16),
                  const Text('Payment', style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(order.paymentMethod == 'cash' ? 'Cash on Delivery' : 'Card',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Total', style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      Text('\$${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ]),
                  ),

                  const SizedBox(height: 20),
                  if (order.canCancel)
                    OutlinedButton(
                      onPressed: () => _confirmCancel(order),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Cancel Order',
                          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                    ),
                  if (order.canRefund) ...[
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => _confirmRefund(order),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Request Refund',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => _confirmArchive(order),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Archive Order',
                        style: TextStyle(color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
