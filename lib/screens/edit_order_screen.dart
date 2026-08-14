import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/order_store.dart';

/// Backend: PUT /user/orders/{id} accepts 
class EditOrderScreen extends StatefulWidget {
  final int orderId;
  const EditOrderScreen({super.key, required this.orderId});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  late String _paymentMethod;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final order = OrderStore.instance.getById(widget.orderId);
    _addressController = TextEditingController(text: order?.address ?? '');
    _notesController = TextEditingController(text: order?.notes ?? '');
    _paymentMethod = order?.paymentMethod ?? 'cash';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      OrderStore.instance.updateOrder(
        widget.orderId,
        address: _addressController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        paymentMethod: _paymentMethod,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order updated successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Text('Edit Order', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Delivery Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Address is required' : null,
                        decoration: InputDecoration(
                          hintText: 'Street, city, country',
                          filled: true,
                          fillColor: AppColors.cardWhite,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppColors.border)),
                        ),
                      ),

                      const SizedBox(height: 22),
                      const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: _PayOption(label: 'Cash on Delivery', icon: Icons.payments_outlined,
                            isSelected: _paymentMethod == 'cash', onTap: () => setState(() => _paymentMethod = 'cash'))),
                        const SizedBox(width: 12),
                        Expanded(child: _PayOption(label: 'Card', icon: Icons.credit_card_outlined,
                            isSelected: _paymentMethod == 'card', onTap: () => setState(() => _paymentMethod = 'card'))),
                      ]),

                      const SizedBox(height: 22),
                      const Text('Notes (optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'e.g. Leave at the door',
                          filled: true,
                          fillColor: AppColors.cardWhite,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppColors.border)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                child: _isLoading
                    ? const SizedBox(height: 22, width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PayOption({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Column(children: [
          Icon(icon, size: 22, color: isSelected ? Colors.white : AppColors.textPrimary),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textPrimary)),
        ]),
      ),
    );
  }
}
