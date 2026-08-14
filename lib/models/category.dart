import 'package:flutter/material.dart';


class Category {
  final int id;
  final String name;
  final String? image;
  final int productsCount;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    this.image,
    this.productsCount = 0,
    this.icon = Icons.category_outlined,
  });
}

/// Mock 
final List<Category> mockCategories = [
  const Category(id: 1, name: 'Dresses',     productsCount: 14, icon: Icons.checkroom_outlined),
  const Category(id: 2, name: 'Shirts',      productsCount: 22, icon: Icons.dry_cleaning_outlined),
  const Category(id: 3, name: 'Shoes',       productsCount: 18, icon: Icons.ice_skating_outlined),
  const Category(id: 4, name: 'Bags',        productsCount: 9,  icon: Icons.shopping_bag_outlined),
  const Category(id: 5, name: 'Jackets',     productsCount: 11, icon: Icons.checkroom_rounded),
  const Category(id: 6, name: 'Pants',       productsCount: 16, icon: Icons.accessibility_outlined),
  const Category(id: 7, name: 'Sweaters',    productsCount: 7,  icon: Icons.line_style_outlined),
  const Category(id: 8, name: 'Accessories', productsCount: 20, icon: Icons.watch_outlined),
];