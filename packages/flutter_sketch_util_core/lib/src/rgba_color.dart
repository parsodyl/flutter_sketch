import 'package:vector_math/vector_math.dart';

class RgbaColor {
  final Vector4 _vector;

  RgbaColor._(this._vector);

  factory RgbaColor(int red, int green, int blue, [int alpha = 255]) {
    final vector = Vector4.zero();
    Colors.fromRgba(
      red.normalize(),
      green.normalize(),
      blue.normalize(),
      alpha.normalize(),
      vector,
    );
    return RgbaColor._(vector);
  }

  factory RgbaColor.grayscale(int value, [int alpha = 255]) {
    final vector = Vector4.zero();
    Colors.fromRgba(
      value.normalize(),
      value.normalize(),
      value.normalize(),
      alpha.normalize(),
      vector,
    );
    return RgbaColor._(vector);
  }

  factory RgbaColor.fromHexString(String hexString) {
    final vector = Vector4.zero();
    Colors.fromHexString(hexString, vector);
    return RgbaColor._(vector);
  }

  int get red => _vector.r.toByte();

  set red(int value) => _vector.r = value.normalize().toFloat();

  int get green => _vector.g.toByte();

  set green(int value) => _vector.g = value.normalize().toFloat();

  int get blue => _vector.b.toByte();

  set blue(int value) => _vector.b = value.normalize().toFloat();

  int get alpha => _vector.a.toByte();

  set alpha(int value) => _vector.a = value.normalize().toFloat();
}

extension _$int on int {
  int normalize() => clamp(0, 255).toInt();

  double toFloat() => this / 255;
}

extension _$double on double {
  int toByte() => (this * 255).toInt();
}
