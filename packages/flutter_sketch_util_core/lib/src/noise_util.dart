// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:vector_math/vector_math.dart' as v;

final simplex = ExtendedSimplex._();

class ExtendedSimplex {
  ExtendedSimplex._([int? seed])
      : _currentSeed = seed,
        _currentSimplex = v.SimplexNoise(Random(seed));

  int? _currentSeed;

  int? get currentSeed => _currentSeed;

  v.SimplexNoise _currentSimplex = v.SimplexNoise();

  void setSeed(int? seed) {
    _currentSeed = seed;
    _currentSimplex = v.SimplexNoise(Random(seed));
  }

  double noise2D(
    double x,
    double y, [
    double frequency = 1,
    double amplitude = 1,
  ]) {
    return amplitude *
        _currentSimplex.noise2D(
          x * frequency,
          y * frequency,
        );
  }

  double noise3D(
    double x,
    double y,
    double z, [
    double frequency = 1,
    double amplitude = 1,
  ]) {
    return amplitude *
        _currentSimplex.noise3D(
          x * frequency,
          y * frequency,
          z * frequency,
        );
  }

  double noise4D(
    double x,
    double y,
    double z,
    double w, [
    double frequency = 1,
    double amplitude = 1,
  ]) {
    return amplitude *
        _currentSimplex.noise4D(
          x * frequency,
          y * frequency,
          z * frequency,
          w * frequency,
        );
  }
}
