import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class SketchController {
  SketchController(this.context);

  final BuildContext context;
  final _rePainter = RePainter();

  int _frameCount = 0;
  int _actualFrameRate = 0;

  _FrameRateCalculator _frameRateCalculator =
      _FrameRateCalculator(Duration.zero, 0);

  bool _isRendering = false;

  RePainter get rePainter => _rePainter;

  void updateSketcher(Sketcher sketcher) {
    _rePainter.updateSketcher(sketcher);
  }

  void render() {
    // filter unwanted elaborations
    if (_isRendering) return;

    // register after frame callback
    SchedulerBinding.instance.endOfFrame.then((_) {
      if (!_isRendering) return;

      // update frame count
      _frameCount++;

      // update state
      _isRendering = false;
    });

    // apply rendering
    _isRendering = true;
    _rePainter.paint(
      context,
      SketchProps._(_actualFrameRate, _frameCount),
    );
  }

  void onTick(Duration elapsedTime, int ticks) {
    // filter unwanted elaborations
    if (_isRendering) return;

    // calculate frame rate
    if (_frameRateCalculator.isSecondReached) {
      _actualFrameRate = _frameRateCalculator.frameRate;
      _frameRateCalculator = _FrameRateCalculator(elapsedTime, _frameCount);
    } else {
      _frameRateCalculator.update(elapsedTime, _frameCount);
    }
    // render
    render();
  }

  void dispose() {
    _rePainter.dispose();
  }
}

typedef Sketcher = Painter Function(BuildContext context, SketchProps props);

typedef Painter = void Function(Canvas canvas, Size size, Paint basePaint);

class RePainter extends ChangeNotifier {
  Sketcher? _sketcher;

  RePainter();

  Painter? _painter;

  Painter? get painter => _painter;

  void updateSketcher(Sketcher sketcher) {
    _sketcher = sketcher;
  }

  void paint(BuildContext context, SketchProps props) {
    _painter = _sketcher?.call(context, props);
    notifyListeners();
  }
}

class SketchProps {
  SketchProps._(this.frameRate, this.frameCount);

  final int frameRate;
  final int frameCount;
}

class _FrameRateCalculator {
  _FrameRateCalculator(
    this.initialElapsedTime,
    this.initialFrames,
  );

  final Duration initialElapsedTime;
  final int initialFrames;

  Duration? _currentElapsedTime;

  Duration get currentElapsedTime => _currentElapsedTime ?? initialElapsedTime;

  int? _currentFrames;

  int get currentFrames => _currentFrames ?? initialFrames;

  void update(Duration elapsedTime, int frames) {
    _currentElapsedTime = elapsedTime;
    _currentFrames = frames;
  }

  bool get isSecondReached =>
      currentElapsedTime - initialElapsedTime >= const Duration(seconds: 1);

  int get frameRate => ((currentFrames - initialFrames) /
          (currentElapsedTime - initialElapsedTime).inSeconds)
      .round();
}
