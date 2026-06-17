import 'package:flutter/material.dart';

/// Color swatch option used in the product filter
class ColorOption {
  final String name;
  final Color color;

  const ColorOption({required this.name, required this.color});
}

/// Mock color options for filtering (matches backend's `color` query param)
final List<ColorOption> mockColorOptions = [
  const ColorOption(name: 'Black', color: Color(0xFF1A1A1A)),
  const ColorOption(name: 'White', color: Color(0xFFFFFFFF)),
  const ColorOption(name: 'Brown', color: Color(0xFF8A5A44)),
  const ColorOption(name: 'Beige', color: Color(0xFFE3D5CD)),
  const ColorOption(name: 'Navy', color: Color(0xFF2C3E66)),
  const ColorOption(name: 'Red', color: Color(0xFFB3261E)),
  const ColorOption(name: 'Green', color: Color(0xFF4C7A50)),
  const ColorOption(name: 'Pink', color: Color(0xFFE8A4B0)),
];

/// Mock size options for filtering (matches backend's `size` query param)
final List<String> mockSizeOptions = ['S', 'M', 'L', 'XL'];
