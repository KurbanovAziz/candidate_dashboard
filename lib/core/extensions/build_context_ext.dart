import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  ColorScheme get color => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;

  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 600;

  double get pageHorizontalPadding {
    final width = MediaQuery.sizeOf(this).width;
    return (width * 0.04).clamp(16.0, 32.0);
  }

  double get bottomContentPadding {
    return MediaQuery.paddingOf(this).bottom + 24;
  }
}
