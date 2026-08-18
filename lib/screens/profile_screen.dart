import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'my_orders_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'wallet_screen.dart';
import 'login_screen.dart';
import 'forgot_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
              const SizedBox(height: 24),

              // Avatar + name
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.person_rounded, size: 32, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Yazan Khalifa', style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      SizedBox(height: 4),
                      Text('yazan@email.com', style: TextStyle(fontSize: 12.5,
                          color: AppColors.textSecondary)),
                    ],
                  )),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.background,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 24),

              _Item(icon: Icons.receipt_long_outlined, label: 'My Orders',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MyOrdersScreen()))),

              _Item(icon: Icons.account_balance_wallet_outlined, label: 'My Wallet',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WalletScreen()))),

              _Item(icon: Icons.notifications_none_rounded, label: 'Notifications',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()))),

              _Item(icon: Icons.lock_outline_rounded, label: 'Change Password',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()))),

              const SizedBox(height: 12),
              const Divider(color: AppColors.border),
              const SizedBox(height: 12),

              _Item(icon: Icons.logout_rounded, label: 'Logout',
                  isDestructive: true,
                  onTap: () => _handleLogout(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Logout?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to logout?',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              // Backend note: POST /logout with Authorization: Bearer {token}
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text('Logout',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _Item({required this.icon, required this.label,
    required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Icon(icon, size: 20, color: isDestructive ? AppColors.error : AppColors.primary),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDestructive ? AppColors.error : AppColors.textPrimary))),
          if (!isDestructive)
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textHint),
        ]),
      ),
    );
  }
}
