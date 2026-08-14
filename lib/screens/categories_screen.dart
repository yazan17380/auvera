import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';
import 'category_products_screen.dart';

/// Backend: GET /user/categories
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Text('Categories', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 1.1,
                ),
                itemCount: mockCategories.length,
                itemBuilder: (context, index) => _CategoryCard(category: mockCategories[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: category)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          category.image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(category.image!, width: 56, height: 56, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(category.icon, size: 36, color: AppColors.primary)))
              : Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(category.icon, size: 28, color: AppColors.primary),
                ),
          const SizedBox(height: 12),
          Text(category.name, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('${category.productsCount} items', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        ]),
      ),
    );
  }
}
