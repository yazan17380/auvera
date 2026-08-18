import 'package:flutter/material.dart';
import '../theme/app_theme.dart';



class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _balance = 120.50;
  final List<Map<String, dynamic>> _transactions = [
    {'amount': 50.0, 'type': 'add', 'description': 'Wallet top-up', 'date': '2026-08-10'},
    {'amount': 70.50, 'type': 'add', 'description': 'Wallet top-up', 'date': '2026-07-25'},
  ];

  void _showAddBalanceSheet() {
    final controller = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 20),
            const Text('Add Balance', style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 18),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount (\$)',
                filled: true, fillColor: AppColors.cardWhite,
                prefixIcon: const Icon(Icons.attach_money_rounded, color: AppColors.primary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                filled: true, fillColor: AppColors.cardWhite,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(controller.text.trim());
                if (amount == null || amount < 1) return;

                // Backend: POST /wallet/add { amount, description }
                setState(() {
                  _balance += amount;
                  _transactions.insert(0, {
                    'amount': amount,
                    'type': 'add',
                    'description': descController.text.trim().isEmpty
                        ? 'Wallet top-up'
                        : descController.text.trim(),
                    'date': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                  });
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('\$$amount added to your wallet')),
                );
              },
              child: const Text('Add Balance'),
            ),
          ]),
        ),
      ),
    );
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
                Text('My Wallet', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
              ]),
            ),
            const SizedBox(height: 16),

            // Balance card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Current Balance', style: TextStyle(
                      color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('\$${_balance.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddBalanceSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Add Balance', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ]),
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerLeft,
                  child: Text('Transactions', style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontSize: 16))),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _transactions.isEmpty
                  ? const Center(child: Text('No transactions yet',
                      style: TextStyle(color: AppColors.textHint)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final t = _transactions[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(14)),
                          child: Row(children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add_rounded,
                                  color: AppColors.success, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(t['description'], style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                              Text(t['date'], style: const TextStyle(
                                  fontSize: 11, color: AppColors.textHint)),
                            ])),
                            Text('+\$${(t['amount'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w700, color: AppColors.success)),
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
