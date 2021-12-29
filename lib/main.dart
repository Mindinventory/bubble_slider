import 'dart:math';

import 'package:flutter/material.dart';

import 'slider/widget.dart';
import 'slider/render.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BubbleDemo(),
    );
  }
}

class BubbleDemo extends StatefulWidget {
  BubbleDemo({Key? key}) : super(key: key);

  @override
  BubbleDemoState createState() => BubbleDemoState();
}

class BubbleDemoState extends State<BubbleDemo> with TickerProviderStateMixin {
  double _value = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bubble Slider',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            height: 20,
            child: BubbleSlider(
              value: _value,
              bubbleCurveLength: 10,
              isBubbleVisible: true,
              onChanged: (val) {
                _value = val;
              },
              onChangeEnd: (s) {},
              color: Colors.blue,
              demoState: this,
            ),
          ),
        ),
      ),
    );
  }
}
