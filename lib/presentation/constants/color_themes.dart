import 'package:flutter/material.dart';
import 'package:test_app/data/models/branch_theme.dart';

abstract class ColorThemes {
  static const defaultColorTheme = BranchTheme(Color(0xFF6202EE), Color(0xFFB5C9FD));

  static const colorThemes = [
    BranchTheme(Color(0xFFF57C00), Color(0xFFFFE0B2)),
    BranchTheme(Color(0xFF388E3C), Color(0xFFA5D6A7)),
    BranchTheme(Color(0xFF0277BD), Color(0xFFB3E5FC)),
    defaultColorTheme,
  ];
}
