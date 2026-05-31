import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFEAF7FF);
  static const primary = Color(0xFF1677F2);
  static const primaryDark = Color(0xFF005ECC);
  static const textDark = Color(0xFF081226);
  static const textLight = Color(0xFF6B7A99);
  static const green = Color(0xFF16A34A);
  static const red = Color(0xFFFF3B5C);
}

BoxDecoration softCard() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.10),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

BoxDecoration blueGradientCard() {
  return BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF3BA1FF), Color(0xFF0F73F6)],
    ),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.25),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}