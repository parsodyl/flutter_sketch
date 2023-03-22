import 'package:flutter/material.dart';
import 'package:flutter_sketch/flutter_sketch.dart';
import 'package:flutter_sketch_util/flutter_sketch_util.dart';

class Sketch01 extends StatefulWidget {
  const Sketch01({Key? key}) : super(key: key);

  @override
  State<Sketch01> createState() => _Sketch01State();
}

class _Sketch01State extends State<Sketch01> {
  @override
  Widget build(BuildContext context) {
    return FlutterSketch(
      backgroundColor: Colors.white,
      sketcher: (context, props) => (canvas, size, basePaint) {
        basePaint
          ..color = Colors.teal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

        final w = size.width * 0.10;
        final h = size.height * 0.10;
        final gap = size.width * 0.03;
        final ix = size.width * 0.17;
        final iy = size.height * 0.17;

        final off = size.width * 0.02;

        const num = 5;
        for (var i = 0; i < num; i++) {
          for (var j = 0; j < num; j++) {
            // x and y definitions
            final x = ix + (w + gap) * i;
            final y = iy + (h + gap) * j;
            // main rect
            canvas.drawRect(
              Rect.fromLTWH(x, y, w, h),
              basePaint,
            );
            // secondary rect
            if (random.value() > 0.5) {
              canvas.drawRect(
                Rect.fromLTWH(x + off / 2, y + off / 2, w - off, h - off),
                basePaint,
              );
            }
          }
        }
      },
    );
  }
}
