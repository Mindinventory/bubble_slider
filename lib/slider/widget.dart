import 'dart:async';
import 'dart:math';

import 'package:demo/slider/render.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class BubbleSlider extends StatefulWidget {
  BubbleSlider(
      {Key? key,
      required this.value,
      this.bubbleCurveLength = 0,
      this.isBubbleVisible = false,
      this.onChangeStart,
      required this.onChanged,
      required this.demoState,
      this.onChangeEnd,
      this.color = Colors.blue})
      : assert(value >= 0.0 && value <= 100.0),
        assert(bubbleCurveLength >= 0),
        super(key: key);

  final double value;
  final double bubbleCurveLength;
  final bool isBubbleVisible;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final Color color;
  final BubbleDemoState demoState;

  @override
  BubbleSliderState createState() => BubbleSliderState();
}

class BubbleSliderState extends State<BubbleSlider>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  Timer? animationEndTimer;
  List<BubbleAnimation> bubblesList = [];
  List<AnimationController> animationControllers = [];
  List<int> vals = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    animationEndTimer?.cancel();
    animationController.dispose();
    for (int i = 0; i < animationControllers.length; i++) {
      animationControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BubbleSliderWidget(
      value: widget.value,
      bubbleCurveLength: widget.bubbleCurveLength,
      showBubble: widget.isBubbleVisible,
      onChangeStart: widget.onChangeStart,
      onChanged: (val) {
        widget.onChanged;
        if (vals.contains((val * 100).round())) {
          bubblesList.add(BubbleAnimation(
              cal: 0.0,
              radius: 0.0,
              label: (val * 100).round().toString(),
              yOffset: 0.0));
          final AnimationController controllers = AnimationController(
              vsync: this,
              duration: Duration(seconds: 3),
              lowerBound: 1,
              upperBound: 180);
          animationControllers.add(controllers);
          for (int i = 0; i < animationControllers.length; i++) {
            animationControllers[i].addListener(() {
              bubblesList[i].cal =
                  30 * sin((animationControllers[i].value) * pi / 90);
              bubblesList[i].radius = (40 *
                  (min(animationControllers[i].value, 180 - animationControllers[i].value) /
                      90.0));
              bubblesList[i].yOffset = animationControllers[i].value;
            });
          }
          for (int i = 0; i < animationControllers.length; i++) {
            if (!animationControllers[i].isAnimating) {
              animationControllers[i].forward();
            }
          }
        }
      },
      onChangeEnd: widget.onChangeEnd,
      color: widget.color,
      state: this,
    );
  }
}

class BubbleAnimation {
  double radius;
  double cal;
  double yOffset;
  final String label;
  BubbleAnimation(
      {required this.cal,
      required this.radius,
      required this.label,
      required this.yOffset});
}
