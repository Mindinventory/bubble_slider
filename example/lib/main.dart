import 'package:bubble_slider/bubble_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BubbleDemo(),
    );
  }
}

class BubbleDemo extends StatefulWidget {
  const BubbleDemo({Key? key}) : super(key: key);

  @override
  BubbleDemoState createState() => BubbleDemoState();
}

class BubbleDemoState extends State<BubbleDemo> with TickerProviderStateMixin {
  double _value = 100.0;
  final double _min = 50.0;
  final double _max = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              min: _min,
              max: _max,
              bubbleSize: BubbleSize.medium,
              thumbRadiusSpeed: ThumbRadiusSpeed.veryFast,
              bubblesSpeed: BubbleSpeed.veryFast,
              isBubbleVisible: true,
              onChanged: (val) {
                _value = val;
              },
              onChangeEnd: (s) {},
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
