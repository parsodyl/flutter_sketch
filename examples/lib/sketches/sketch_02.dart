import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sketch/flutter_sketch.dart';
import 'package:flutter_sketch_util/flutter_sketch_util.dart';

class Sketch02 extends StatelessWidget {
  const Sketch02({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSketch(
      backgroundColor: Colors.white,
      sketcher: (context, props) => (canvas, size, basePaint) {
        final c = Offset(
          size.width * .5,
          size.height * .5,
        );

        final width = size.width * 0.01;
        final height = size.height * 0.1;

        const num = 40;
        final radius = size.width * 0.3;

        for (var i = 0; i < num; i++) {
          final slice = degToRad(360 / num);
          final angle = slice * i;

          final x = c.dx + radius * sin(angle);
          final y = c.dy + radius * cos(angle);

          canvas.save();
          canvas.translate(x, y);
          canvas.rotate(-angle);
          canvas.scale(random.range(0.1, 2), random.range(0.2, 0.5));

          basePaint.style = PaintingStyle.fill;

          canvas.drawRect(
            Rect.fromLTWH(
              -width * 0.5,
              random.range(0, -height * 0.5),
              width,
              height,
            ),
            basePaint,
          );
          canvas.restore();

          canvas.save();
          canvas.translate(c.dx, c.dy);
          canvas.rotate(-angle);

          basePaint.strokeWidth = random.range(5, 20);
          basePaint.style = PaintingStyle.stroke;

          canvas.drawArc(
            Rect.fromCircle(
              center: Offset.zero,
              radius: radius * random.range(0.7, 1.3),
            ),
            slice * random.range(1, -8),
            slice * random.range(1, 5),
            false,
            basePaint,
          );
          canvas.restore();
        }
      },
    );
  }
}
