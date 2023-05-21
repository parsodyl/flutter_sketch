import 'dart:ui';

import 'package:flutter_sketch_util_core/flutter_sketch_util_core.dart';

extension RgbaColorExtension on RgbaColor {
  Color toColor() => Color.fromARGB(alpha, red, green, blue);
}

extension ColorExtension on Color {
  RgbaColor toRgbaColor() => RgbaColor(red, green, blue, alpha);
}
