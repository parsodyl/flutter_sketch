import 'package:flutter/material.dart';
import 'package:flutter_sketch/flutter_sketch.dart';
import 'package:flutter_sketch_util/flutter_sketch_util.dart';

class Sketch03 extends StatefulWidget {
  const Sketch03({Key? key}) : super(key: key);

  @override
  State<Sketch03> createState() => _Sketch03State();
}

class _Sketch03State extends State<Sketch03> {
  late final agents = _generateAgents();

  List<Agent> _generateAgents() {
    const count = 60;
    final generatedAgents = List.generate(count, (_) {
      final windowSize = MediaQuery.of(context).size;
      final x = random.range(0, windowSize.width);
      final y = random.range(0, windowSize.height);
      return Agent(x, y);
    });
    return generatedAgents;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSketch(
      backgroundColor: Colors.white,
      animate: true,
      animatorType: AnimatorType.ticker,
      fps: 30,
      sketcher: (context, props) => (canvas, size, basePaint) {
        // iterate to draw lines
        for (var i = 0; i < agents.length; i++) {
          final agent = agents[i];
          for (var j = i + 1; j < agents.length; j++) {
            final other = agents[j];

            // ignore far distances
            final dist = (agent.pos - other.pos).distance;
            if (dist > 100) {
              continue;
            }

            // draw a single connecting line
            canvas.drawLine(
              agent.pos,
              other.pos,
              basePaint
                ..style = PaintingStyle.stroke
                ..strokeWidth = dist.mapRange(0, 100, 10, 1),
            );
          }
        }

        // draw agents
        for (var agent in agents) {
          agent.update();
          agent.bounce(size.width, size.height);
          agent.draw(canvas, basePaint);
        }
      },
    );
  }
}

class Agent {
  Offset pos;
  Vector2 vel = Vector2.all(random.range(-1, 1));
  final double radius = random.range(4, 12);

  Agent(double x, double y) : pos = Offset(x, y);

  void update() {
    pos += vel.toOffset();
  }

  void bounce(double width, double height) {
    if (pos.dx.isOutOfRange(0, width)) {
      vel.x *= -1;
    }
    if (pos.dy.isOutOfRange(0, height)) {
      vel.y *= -1;
    }
  }

  void draw(Canvas canvas, Paint basePaint, [double strokeWidth = 2.0]) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);

    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      basePaint..strokeWidth = strokeWidth,
    );
    canvas.restore();
  }
}
