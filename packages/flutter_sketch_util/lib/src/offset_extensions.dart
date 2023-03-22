import 'dart:ui';

import 'package:flutter_sketch_util_core/flutter_sketch_util_core.dart';

extension Vector2Extension on Vector2 {
  Offset toOffset() => Offset(x, y);
}

extension OffsetExtension on Offset {
  Vector2 toVector2() => Vector2(dx, dy);
}
