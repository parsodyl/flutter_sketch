import 'package:flutter/widgets.dart';
import 'package:flutter_sketch/src/sketch_animator.dart';
import 'package:flutter_sketch/src/sketch_controller.dart';

enum AnimatorType {
  ticker,
  periodicTimer,
}

class FlutterSketch extends StatefulWidget {
  const FlutterSketch({
    Key? key,
    required this.sketcher,
    this.width,
    this.height,
    this.backgroundColor,
    this.animate = false,
    this.animatorType = AnimatorType.ticker,
    this.fps = 60,
  }) : super(key: key);

  final Sketcher sketcher;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool animate;
  final AnimatorType animatorType;
  final int fps;

  @override
  State<FlutterSketch> createState() => _FlutterSketchState();
}

class _FlutterSketchState extends State<FlutterSketch>
    with TickerProviderStateMixin {
  late final _sketchController = SketchController(context);

  SketchAnimator? _animator;

  @override
  void initState() {
    super.initState();

    _setupAnimation();
  }

  @override
  void didUpdateWidget(covariant FlutterSketch oldWidget) {
    super.didUpdateWidget(oldWidget);

    // check animation settings
    if (widget.animate != oldWidget.animate ||
        widget.animatorType != oldWidget.animatorType) {
      _setupAnimation();
    } else if (widget.fps != oldWidget.fps) {
      _animator?.fps = widget.fps;
    }
  }

  void _setupAnimation() {
    _animator?.cancel();
    if (widget.animate) {
      switch (widget.animatorType) {
        case AnimatorType.ticker:
          _animator = TickerSketchAnimator(
            _sketchController,
            widget.fps,
            this,
          );
          break;
        case AnimatorType.periodicTimer:
          _animator = PeriodicTimerSketchAnimator(
            _sketchController,
            widget.fps,
          );
          break;
      }
      _animator?.play();
    } else {
      _animator = null;
    }
  }

  @override
  void dispose() {
    _animator?.cancel();
    _sketchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sketchController.updateSketcher(widget.sketcher);
    _sketchController.render();
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: CustomPaint(
        painter: _SketchPainter(_sketchController.rePainter),
      ),
    );
  }
}

class _SketchPainter extends CustomPainter {
  final RePainter rePainter;

  _SketchPainter(this.rePainter) : super(repaint: rePainter);

  @override
  void paint(Canvas canvas, Size size) {
    final painter = rePainter.painter;
    return painter?.call(canvas, size, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
