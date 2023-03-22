import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_sketch/src/sketch_controller.dart';

abstract class SketchAnimator {
  SketchAnimator(this._sketchController, this._fps) : assert(_fps > 0);

  final SketchController _sketchController;
  int _fps;

  Duration _lastTickElapsedTime = Duration.zero;
  int _currentTickNumber = 0;

  set fps(int value) {
    _fps = value;
  }

  bool _isAnimating = false;

  bool get isAnimating => _isAnimating;

  Duration get _requestedFrameTime =>
      Duration(milliseconds: (1000.0 / _fps).floor());

  void _resetState() {
    _lastTickElapsedTime = Duration.zero;
    _currentTickNumber = 0;
  }

  void _updateStateAndRender(Duration elapsedTime) {
    _lastTickElapsedTime = elapsedTime;
    _currentTickNumber++;
    // render
    _sketchController.onTick(_lastTickElapsedTime, _currentTickNumber);
  }

  void play();

  void cancel();
}

class TickerSketchAnimator extends SketchAnimator {
  TickerSketchAnimator(super.sketchController, super.fps, this._tickerProvider);

  final TickerProvider _tickerProvider;

  Ticker? _ticker;

  @override
  void play() {
    // enforce cancel
    cancel();
    // create a new ticker
    _ticker = _tickerProvider.createTicker((elapsedTime) {
      // filter spare ticks
      if (elapsedTime - _lastTickElapsedTime < _requestedFrameTime) {
        return;
      } else {
        // update internal state and render
        _updateStateAndRender(elapsedTime);
      }
    });
    _ticker?.start();
    _isAnimating = true;
  }

  @override
  void cancel() {
    // cancel ticker
    _ticker?.dispose();
    _ticker = null;
    // reset state
    _resetState();
    _isAnimating = false;
  }
}

class PeriodicTimerSketchAnimator extends SketchAnimator {
  PeriodicTimerSketchAnimator(super.sketchController, super.fps);

  Timer? _timer;
  DateTime _startDateTime = DateTime.now();

  @override
  void play() {
    // enforce cancel
    cancel();
    // create a new timer
    _setupTimer();
    _startDateTime = DateTime.now();
    _isAnimating = true;
  }

  @override
  set fps(int value) {
    super.fps = value;

    if (_isAnimating) {
      _timer?.cancel();
      _setupTimer();
    }
  }

  void _setupTimer() {
    _timer = Timer.periodic(
      _requestedFrameTime,
      (timer) {
        // update internal state and render
        final elapsedTime = DateTime.now().difference(_startDateTime);
        _updateStateAndRender(elapsedTime);
      },
    );
  }

  @override
  void cancel() {
    // cancel timer
    _timer?.cancel();
    _timer = null;
    // reset state
    _resetState();
    _isAnimating = false;
  }
}
