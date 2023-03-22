import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sketch/flutter_sketch.dart';
import 'package:flutter_sketch_util/flutter_sketch_util.dart';

class Sketch04 extends StatelessWidget {
  const Sketch04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSketch(
      backgroundColor: Colors.white,
      animate: true,
      fps: 30,
      sketcher: (context, props) => (canvas, size, basePaint) {
        // cols and rows
        const cols = 10;
        const rows = 10;

        // set size variables
        final gridWidth = size.width * 0.8;
        final gridHeight = size.height * 0.8;
        final cellWidth = gridWidth / cols;
        final cellHeight = gridHeight / rows;
        final marginX = (size.width - gridWidth) * 0.5;
        final marginY = (size.height - gridHeight) * 0.5;

        // generate grid
        GridIterator(cols, rows).forEachCell((colIndex, rowIndex) {
          // get relative constraints
          final x = colIndex * cellWidth;
          final y = rowIndex * cellHeight;
          final w = cellWidth * 0.8;
          final h = cellHeight * 0.8;

          // tweak noise
          final frame = props.frameCount;
          final n = simplex.noise3D(x, y, frame * 10, 0.001);
          final angle = n * pi * 0.2;
          final scale = n.mapRange(-1, 1, 1, 30);

          // transform canvas
          canvas.save();
          canvas.translate(x, y);
          canvas.translate(marginX, marginY);
          canvas.translate(cellWidth * .5, cellHeight * .5);
          canvas.rotate(angle);

          // set paint
          basePaint
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = scale;

          // draw single line
          canvas.drawLine(
            Offset(w * -0.5, 0),
            Offset(h * 0.5, 0),
            basePaint,
          );
          canvas.restore();
        });
      },
    );
  }
}
