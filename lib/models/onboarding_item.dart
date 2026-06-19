import 'package:flutter/material.dart';


class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

final List<OnboardingItem> onboardingItems = [
  const OnboardingItem(
    title: 'Discover Unique Styles',
    description: 'Browse thousands of curated products picked just for your taste.',
    icon: Icons.checkroom_outlined,
  ),
  const OnboardingItem(
    title: 'Easy & Secure Checkout',
    description: 'Pay with confidence using safe and seamless payment options.',
    icon: Icons.shopping_bag_outlined,
  ),
  const OnboardingItem(
    title: 'Fast Delivery to You',
    description: 'Track your orders in real time and get them delivered quickly.',
    icon: Icons.local_shipping_outlined,
  ),
];
