import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'bubble_slider_widget.dart';

/// Bubble slider widget
class BubbleSlider extends StatefulWidget {
  const BubbleSlider(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.onChangeEnd,
      this.isBubbleVisible = false,
      this.onChangeStart,
      this.color = Colors.blue})
      : assert(value >= 0.0 && value <= 100.0),
        super(key: key);

  ///This is for value of slider and allow value from 0 to 100
  final double value;

  ///This is for bubble hide and show
  final bool isBubbleVisible;

  ///This function called when user start drag of slider.
  final ValueChanged<double>? onChangeStart;

  ///This function called when value change of slider.
  final ValueChanged<double> onChanged;

  ///This function called when user end drag of slider.
  final ValueChanged<double> onChangeEnd;

  ///This indicates the color of slider as well as bubbles.
  final Color color;

  @override
  BubbleSliderState createState() => BubbleSliderState();
}

class BubbleSliderState extends State<BubbleSlider>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController valueAnimationController;
  Timer? animationEndTimer;
  List<BubbleAnimation> bubblesList = [];
  List<AnimationController> animationControllers = [];
  List<int> vals = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    valueAnimationController = AnimationController(
        lowerBound: 0,
        upperBound: 20,
        vsync: this,
        duration: const Duration(milliseconds: 600));
    valueAnimationController.addListener(() {
      if (valueAnimationController.isCompleted) {
        valueAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    animationEndTimer?.cancel();
    animationController.dispose();
    valueAnimationController.dispose();
    for (int i = 0; i < animationControllers.length; i++) {
      animationControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BubbleSliderWidget(
      value: widget.value / 100,
      showBubble: widget.isBubbleVisible,
      onChangeStart: widget.onChangeStart,
      onChanged: (val) {
        widget.onChanged(val);
        bubbleAnimationCalculation(val);
      },
      onChangeEnd: (val) {
        widget.onChangeEnd(val);
        animationControllers.last.addListener(() {
          if (animationControllers.last.isCompleted) {
            valueAnimationController.forward();
          }
        });
      },
      color: widget.color,
      state: this,
    );
  }

  /// This function is for calculate the bubble animation with animation controller for each value.
  /// This function is show the round values like 0, 10, 20...100.
  void bubbleAnimationCalculation(double val) {
    if (vals.contains((val).round())) {
      bubblesList.add(BubbleAnimation(
          cal: 0.0,
          radius: 0.0,
          label: (val).round().toString(),
          yOffset: 0.0));
      final AnimationController controllers = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 3),
          lowerBound: 1,
          upperBound: 180);
      animationControllers.add(controllers);
      for (int i = 0; i < animationControllers.length; i++) {
        animationControllers[i].addListener(() {
          bubblesList[i].cal =
              30 * sin((animationControllers[i].value) * pi / 90);
          bubblesList[i].radius = (45 *
              (min(animationControllers[i].value,
                      180 - animationControllers[i].value) /
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
  }
}

/// This class is for set the value for bubble of radius, offset and numbers.
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
