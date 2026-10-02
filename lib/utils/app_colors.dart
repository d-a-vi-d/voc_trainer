import 'package:flutter/material.dart';

/// Gemeinsame Farben für hellen und dunklen Modus.
/// Hell: wie bisher (weiße Kacheln, schwarzer Rand). Dunkel: dunkelgrau, ohne Rand.
class AppColors {
  AppColors._();

  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  /// Normaler Text: im hellen Modus weiches Schwarz, im dunklen reines Weiß.
  static Color text(BuildContext context) => isDark(context) ? Colors.white : Colors.black87;

  static Color tileBackground(BuildContext context, {bool selected = false}) {
    if (selected) return Colors.green;
    return isDark(context) ? const Color(0xFF2A2A2A) : Colors.white;
  }

  static Border? tileBorder(BuildContext context) =>
      isDark(context) ? null : Border.all(color: Colors.black, width: 3);
}
