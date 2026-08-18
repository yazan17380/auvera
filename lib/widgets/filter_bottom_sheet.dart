import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';


class FilterResult {
  final int? categoryId;       // category_id
  final String? color;         // color (name string)
  final String? size;          // size (name string)
  final RangeValues priceRange; // min_price + max_price
  final bool? inStock;         // in_stock: null=any, true=1, false=0
  final String? sort;          // newest | price_asc | price_desc

  const FilterResult({
    this.categoryId,
    this.color,
    this.size,
    required this.priceRange,
    this.inStock,
    this.sort,
  });

  bool get hasActiveFilter =>
      categoryId != null ||
      color != null ||
      size != null ||
      inStock != null ||
      sort != null ||
      priceRange.start > 0 ||
      priceRange.end < 200;

  /// Build query params map ready to send to backend
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (categoryId != null) params['category_id'] = categoryId;
    if (color != null) params['color'] = color;
    if (size != null) params['size'] = size;
    if (priceRange.start > 0) params['min_price'] = priceRange.start.round();
    if (priceRange.end < 200) params['max_price'] = priceRange.end.round();
    if (inStock != null) params['in_stock'] = inStock! ? 1 : 0;
    if (sort != null) params['sort'] = sort;
    return params;
  }
}

class FilterBottomSheet extends StatefulWidget {
  final FilterResult? initialFilter;

  const FilterBottomSheet({super.key, this.initialFilter});

  static Future<FilterResult?> show(BuildContext context,
      {FilterResult? initialFilter}) {
    return showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(initialFilter: initialFilter),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int? _selectedCategoryId;
  String? _selectedColor;
  String? _selectedSize;
  RangeValues _priceRange = const RangeValues(0, 200);
  bool? _inStock;
  String? _sort;

  static const double _minPrice = 0;
  static const double _maxPrice = 200;

  // Color names matching backend's Color model
  static const List<String> _colors = [
    'Black', 'White', 'Brown', 'Beige', 'Navy', 'Red', 'Green', 'Pink'
  ];

  // Size names matching backend's Size model
  static const List<String> _sizes = ['S', 'M', 'L', 'XL'];

  // Sort options matching backend's sort param
  static const List<Map<String, String>> _sortOptions = [
    {'value': 'newest', 'label': 'Newest First'},
    {'value': 'price_asc', 'label': 'Price: Low to High'},
    {'value': 'price_desc', 'label': 'Price: High to Low'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      final f = widget.initialFilter!;
      _selectedCategoryId = f.categoryId;
      _selectedColor = f.color;
      _selectedSize = f.size;
      _priceRange = f.priceRange;
      _inStock = f.inStock;
      _sort = f.sort;
    }
  }

  void _reset() {
    setState(() {
      _selectedCategoryId = null;
      _selectedColor = null;
      _selectedSize = null;
      _priceRange = const RangeValues(_minPrice, _maxPrice);
      _inStock = null;
      _sort = null;
    });
  }

  void _apply() {
    Navigator.of(context).pop(FilterResult(
      categoryId: _selectedCategoryId,
      color: _selectedColor,
      size: _selectedSize,
      priceRange: _priceRange,
      inStock: _inStock,
      sort: _sort,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border, borderRadius: BorderRadius.circular(4)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filters',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                    GestureDetector(
                      onTap: _reset,
                      child: const Text('Reset', style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  children: [

                    // Category
                    _Label('Category'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: mockCategories.map((cat) {
                        final isSelected = _selectedCategoryId == cat.id;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedCategoryId = isSelected ? null : cat.id;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border),
                            ),
                            child: Text(cat.name, style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textPrimary)),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Color
                    _Label('Color'),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: _colors.map((colorName) {
                        final isSelected = _selectedColor == colorName;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedColor = isSelected ? null : colorName;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border),
                            ),
                            child: Text(colorName, style: TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textPrimary)),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Size
                    _Label('Size'),
                    const SizedBox(height: 12),
                    Row(
                      children: _sizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _selectedSize = isSelected ? null : size;
                            }),
                            child: Container(
                              width: 46, height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.cardWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.border),
                              ),
                              child: Text(size, style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.textPrimary)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Price Range
                    _Label('Price Range'),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _priceRange,
                      min: _minPrice,
                      max: _maxPrice,
                      divisions: 40,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.border,
                      labels: RangeLabels(
                        '\$${_priceRange.start.round()}',
                        '\$${_priceRange.end.round()}',
                      ),
                      onChanged: (v) => setState(() => _priceRange = v),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('\$${_priceRange.start.round()}',
                            style: const TextStyle(fontSize: 13,
                                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('\$${_priceRange.end.round()}',
                            style: const TextStyle(fontSize: 13,
                                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ]),
                    ),

                    const SizedBox(height: 28),

                    // Availability
                    _Label('Availability'),
                    const SizedBox(height: 12),
                    Row(children: [
                      _ToggleChip(label: 'Any', isSelected: _inStock == null,
                          onTap: () => setState(() => _inStock = null)),
                      const SizedBox(width: 10),
                      _ToggleChip(label: 'In Stock', isSelected: _inStock == true,
                          onTap: () => setState(() => _inStock = true)),
                      const SizedBox(width: 10),
                      _ToggleChip(label: 'Out of Stock', isSelected: _inStock == false,
                          onTap: () => setState(() => _inStock = false)),
                    ]),

                    const SizedBox(height: 28),

                    // Sort
                    _Label('Sort By'),
                    const SizedBox(height: 12),
                    Column(
                      children: _sortOptions.map((opt) {
                        final isSelected = _sort == opt['value'];
                        return GestureDetector(
                          onTap: () => setState(() {
                            _sort = isSelected ? null : opt['value'];
                          }),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(opt['label']!, style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.textPrimary)),
                                if (isSelected)
                                  const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: ElevatedButton(
                  onPressed: _apply,
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary));
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Text(label, style: TextStyle(
            fontSize: 12.5, fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary)),
      ),
    );
  }
}
