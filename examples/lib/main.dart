import 'package:examples/sketches/sketch_01.dart';
import 'package:examples/sketches/sketch_02.dart';
import 'package:examples/sketches/sketch_03.dart';
import 'package:examples/sketches/sketch_04.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SafeArea(
        child: Sketch04(),
      ),
    );
  }
}
