import 'dart:math';

import 'package:vector_math/vector_math_64.dart' as v;

typedef Vector2 = v.Vector2;

typedef List2D<T> = List<List<T>>;

List2D<T> generateList2D<T>(
  int rows,
  int cols,
  T Function(int rowIndex, int colIndex) generator,
) {
  return List<List<T>>.generate(
    rows,
    (rowIndex) => List<T>.generate(
      cols,
      (colIndex) => generator(rowIndex, colIndex),
    ),
  );
}

double degToRad(double deg) {
  return deg * (pi / 180.0);
}

double radToDeg(double rad) {
  return rad * 180.0 / pi;
}

extension DoubleExtension on double {
  double mapRange(
    double inputMin,
    double inputMax,
    double outputMin,
    double outputMax, {
    bool clamp = false,
  }) {
    assert((inputMax - inputMin).abs() > double.minPositive);
    final normalizedVal = (this - inputMin) / (inputMax - inputMin);
    var outVal = normalizedVal * (outputMax - outputMin) + outputMin;
    if (clamp) {
      outVal = outVal.clamp(
        outputMin < outputMax ? outputMin : outputMax,
        outputMin > outputMax ? outputMin : outputMax,
      );
    }
    return outVal;
  }

  bool isInRange(
    num lowerLimit,
    num upperLimit, {
    bool includeLimits = true,
  }) {
    if (includeLimits) {
      return this >= lowerLimit || this <= upperLimit;
    } else {
      return this > lowerLimit || this < upperLimit;
    }
  }

  bool isOutOfRange(
    num lowerLimit,
    num upperLimit, {
    bool includeLimits = true,
  }) {
    if (includeLimits) {
      return this <= lowerLimit || this >= upperLimit;
    } else {
      return this < lowerLimit || this > upperLimit;
    }
  }
}

class GridIterator {
  final int cols;
  final int rows;

  GridIterator(this.cols, this.rows);

  int get cellCount => cols * rows;

  void forEachCell(void Function(int colIndex, int rowIndex) action) {
    for (var i = 0; i < cellCount; i++) {
      final colIndex = i % cols;
      final rowIndex = i ~/ cols;
      action(colIndex, rowIndex);
    }
  }
}
