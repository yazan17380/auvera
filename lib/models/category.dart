import 'package:flutter/material.dart';

/// Category data model
/// NOTE: icon is a local placeholder until real category images/icons
/// are available from the backend.
class Category {
  final int id;
  final String name;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}

/// Mock category data for UI building (no backend connection yet)
final List<Category> mockCategories = [
  const Category(id: 1, name: 'All', icon: Icons.apps_rounded),
  const Category(id: 2, name: 'Dresses', icon: Icons.checkroom_outlined),
  const Category(id: 3, name: 'Shirts', icon: Icons.dry_cleaning_outlined),
  const Category(id: 4, name: 'Shoes', icon: Icons.ice_skating_outlined),
  const Category(id: 5, name: 'Bags', icon: Icons.shopping_bag_outlined),
  const Category(id: 6, name: 'Jackets', icon: Icons.checkroom),
];
