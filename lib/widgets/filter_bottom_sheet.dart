import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/category.dart';
import '../models/filter_options.dart';

class FilterResult {
  final Category? category;
  final ColorOption? color;
  final String? size;
  final RangeValues priceRange;

  const FilterResult({
    this.category,
    this.color,
    this.size,
    required this.priceRange,
  });
}

class FilterBottomSheet extends StatefulWidget {
  final FilterResult? initialFilter;

  const FilterBottomSheet({super.key, this.initialFilter});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();

  /// Convenience method to show this as a modal bottom sheet
  static Future<FilterResult?> show(BuildContext context, {FilterResult? initialFilter}) {
    return showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(initialFilter: initialFilter),
    );
  }
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Category? _selectedCategory;
  ColorOption? _selectedColor;
  String? _selectedSize;
  RangeValues _priceRange = const RangeValues(0, 200);

  static const double _minPrice = 0;
  static const double _maxPrice = 200;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _selectedCategory = widget.initialFilter!.category;
      _selectedColor = widget.initialFilter!.color;
      _selectedSize = widget.initialFilter!.size;
      _priceRange = widget.initialFilter!.priceRange;
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedColor = null;
      _selectedSize = null;
      _priceRange = const RangeValues(_minPrice, _maxPrice);
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop(
      FilterResult(
        category: _selectedCategory,
        color: _selectedColor,
        size: _selectedSize,
        priceRange: _priceRange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filters', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  children: [
                    _SectionLabel('Category'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: mockCategories.where((c) => c.name != 'All').map((category) {
                        final isSelected = _selectedCategory?.id == category.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = isSelected ? null : category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.cardWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),
                    _SectionLabel('Color'),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: mockColorOptions.map((colorOption) {
                        final isSelected = _selectedColor?.name == colorOption.name;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = isSelected ? null : colorOption;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: colorOption.color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                        color: _isLightColor(colorOption.color)
                                            ? Colors.black
                                            : Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                colorOption.name,
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),
                    _SectionLabel('Size'),
                    const SizedBox(height: 12),
                    Row(
                      children: mockSizeOptions.map((size) {
                        final isSelected = _selectedSize == size;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = isSelected ? null : size;
                              });
                            },
                            child: Container(
                              width: 46,
                              height: 46,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.cardWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                              ),
                              child: Text(
                                size,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),
                    _SectionLabel('Price Range'),
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
                      onChanged: (values) {
                        setState(() => _priceRange = values);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${_priceRange.start.round()}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('\$${_priceRange.end.round()}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isLightColor(Color color) {
    return color.computeLuminance() > 0.6;
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    );
  }
}
