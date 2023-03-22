import 'dart:math';

final random = ExtendedRandom._();

class ExtendedRandom {
  ExtendedRandom._([int? seed])
      : _currentSeed = seed,
        _currentRandom = Random(seed);

  int? _currentSeed;

  int? get currentSeed => _currentSeed;

  Random _currentRandom;

  double? _nextGaussian;

  void setSeed(int? seed) {
    _currentSeed = seed;
    _currentRandom = Random(seed);
    _nextGaussian = null;
  }

  double value() => _currentRandom.nextDouble();

  double range(double min, double max) {
    return value() * (max - min) + min;
  }

  int nextInt(int max) => _currentRandom.nextInt(max);

  bool nextBool() => _currentRandom.nextBool();

  double nextGaussian([double mean = 0, double standardDeviation = 1]) {
    // see https://github.com/openjdk-mirror/jdk7u-jdk/blob/f4d80957e89a19a29bb9f9807d2a28351ed7f7df/src/share/classes/java/util/Random.java#L496
    if (_nextGaussian != null) {
      final gaussian = _nextGaussian!;
      _nextGaussian = null;
      return mean + standardDeviation * gaussian;
    } else {
      var v1 = 0.0, v2 = 0.0, s = 0.0;
      do {
        v1 = value() * 2 - 1; // between -1 and 1
        v2 = value() * 2 - 1; // between -1 and 1
        s = v1 * v1 + v2 * v2;
      } while (s >= 1 || s == 0);
      var multiplier = sqrt(-2 * log(s) / s);
      _nextGaussian = (v2 * multiplier);
      return mean + standardDeviation * (v1 * multiplier);
    }
  }
}
