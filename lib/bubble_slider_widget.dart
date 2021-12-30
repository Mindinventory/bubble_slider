import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'bubble_slider.dart';

///This class is for render bubbles and slider from custom painter.
class BubbleSliderWidget extends LeafRenderObjectWidget {
  final double value;
  final bool showBubble;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final ValueChanged<double>? onUpdate;
  final Color color;
  final BubbleSliderState state;

  const BubbleSliderWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.state,
    this.showBubble = false,
    this.onChangeStart,
    this.onChangeEnd,
    this.onUpdate,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _BalloonSliderRender(
        value: value,
        showRope: showBubble,
        onChangeStart: onChangeStart,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
        color: color,
        state: state,
        textDirection: Directionality.of(context));
  }

  @override
  void updateRenderObject(
      BuildContext context, _BalloonSliderRender renderObject) {
    renderObject
      ..value = value
      ..showBubble = showBubble
      ..onChangeStart = onChangeStart
      ..onChanged = onChanged
      ..onChangeEnd = onChangeEnd
      ..color = color
      ..textDirection = Directionality.of(context);
  }
}

///This class indicates the custom painter logics for slider and bubbles.
class _BalloonSliderRender extends RenderBox {
  _BalloonSliderRender({
    required double value,
    required Color color,
    required TextDirection textDirection,
    required BubbleSliderState state,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    bool showRope = false,
  })  : assert(value >= 0.0 && value <= 1.0),
        _value = value,
        _color = color,
        _showRope = showRope,
        _textDirection = textDirection,
        _state = state {
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _onDragStart
      ..onUpdate = _onDragUpdate
      ..onEnd = _onDragEnd
      ..onCancel = _onDragCancel;

    _minWidth = 144;
    _minHeight = _trackHeight;

    _buildPaints();
  }

  double get value => _value;
  double _value;

  set value(double val) {
    assert(val >= 0.0 && val <= 1.0);
    if (val == _value) {
      return;
    }
    _value = val;
    markNeedsPaint();
  }

  bool get showBubble => _showRope;
  bool _showRope;

  set showBubble(bool val) {
    if (val == _showRope) {
      return;
    }
    _showRope = val;
    markNeedsPaint();
  }

  ValueChanged<double>? onChangeStart;
  ValueChanged<double> onChanged;
  ValueChanged<double>? onChangeEnd;

  Color get color => _color;
  Color _color;

  set color(Color val) {
    if (val == _color) {
      return;
    }
    _color = val;
    _buildPaints();
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection val) {
    if (val == _textDirection) {
      return;
    }
    _textDirection = val;
    markNeedsPaint();
  }

  final BubbleSliderState _state;
  bool _active = false;
  final double _trackHeight = 8;
  double _currentDragValue = 0.0;

  final double _thumbRadius = 10;
  double _bubbleScale = 0;
  double? _preBalloonOffsetX;
  final double _bubbleWidth = 50;
  final double _bubbleHeight = 70;

  late HorizontalDragGestureRecognizer _drag;
  final TextPainter _textPainter = TextPainter();
  final TextPainter _valueTextPainter = TextPainter();
  late double _minWidth;
  late double _minHeight;

  late Paint _trackPaint;
  late Paint _progressPaint;
  late Paint _thumbPaint;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _state.animationController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _state.animationController.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Canvas canvas = context.canvas;
    canvas.save();

    ///This is indicates the track painter
    Rect trackRect = _getTrackRect(offset: offset);
    canvas.drawRRect(
        RRect.fromRectAndRadius(trackRect, const Radius.circular((10))),
        _trackPaint);

    ///This is indicates the progress of slider
    Rect progressRect = _getTrackRect(offset: offset, progress: _value);
    canvas.drawRRect(
        RRect.fromRectAndRadius(progressRect, const Radius.circular(10)),
        _progressPaint);

    /// This is indicates the thumb painter
    Rect thumbRect = _getThumbRect(
        offset: Offset(
            trackRect.left + _value * trackRect.width, trackRect.center.dy));
    canvas.drawCircle(thumbRect.center,
        _thumbRadius + _state.valueAnimationController.value, _thumbPaint);
    if(_state.bubblesList.isNotEmpty) {
      _valueTextPainter
      ..text = TextSpan(
          text: _state.bubblesList.last.label.toString(),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: _state.valueAnimationController.value))
      ..textDirection = TextDirection.ltr
      ..layout();
    _valueTextPainter.paint(
      canvas,
      Offset((trackRect.left + _value * trackRect.width) - (_state.valueAnimationController.value/2), trackRect.center.dy-(_state.valueAnimationController.value/2)),
    );
    }

    /// This is indicates the bubble painter
    _preBalloonOffsetX ??= thumbRect.center.dx;

    /// babbles position set for curve.
    Rect bubbleRect = _getBalloonRect(
        offset: Offset(_preBalloonOffsetX! - _bubbleWidth / 2, offset.dy),
        parentSize: size);

    double targetOffset = thumbRect.center.dx;
    double diff = thumbRect.center.dx - bubbleRect.center.dx;
    var bubbleOffsetX = _preBalloonOffsetX! + diff / 10.0;
    if (diff > 0) {
      bubbleOffsetX = min(bubbleOffsetX, targetOffset);
    } else {
      bubbleOffsetX = max(bubbleOffsetX, targetOffset);
    }
    double bubbleOffsetY = thumbRect.center.dy - bubbleRect.center.dy;
    double angle = bubbleOffsetY != 0 ? -atan(diff / bubbleOffsetY) : 0;
    _preBalloonOffsetX = bubbleOffsetX;

    canvas.translate(bubbleRect.center.dx, bubbleRect.center.dy);

    if (_active) {
      _bubbleScale = (_bubbleScale + 0.08).clamp(0.0, 1.0);
      canvas.scale(_bubbleScale, _bubbleScale);
    } else {
      _bubbleScale = (_bubbleScale - 0.08).clamp(0.0, 1.0);
      canvas.scale(_bubbleScale, _bubbleScale);
    }

    ///draw bubble
    if (showBubble) {
      for (int i = 0; i < _state.animationControllers.length; i++) {
        final radius = _state.bubblesList[i].radius / 2;
        if (_state.animationControllers[i].value <= 178) {
          canvas.drawCircle(
            Offset(_state.bubblesList[i].cal,
                -(_state.bubblesList[i].yOffset / 2)),
            radius,
            Paint()..color = color,
          );
          final fontSize = _state.bubblesList[i].radius / 3.0;
          final val = _state.bubblesList[i].label;
          _textPainter
            ..text = TextSpan(
                text: val.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize))
            ..textDirection = TextDirection.ltr
            ..layout();
          _textPainter.paint(
            canvas,
            Offset(
                (_state.bubblesList[i].label.length == 1
                        ? _state.bubblesList[i].cal - 5
                        : _state.bubblesList[i].label.length > 2
                            ? _state.bubblesList[i].cal + 5
                            : _state.bubblesList[i].cal) -
                    ((_state.bubblesList[i].label.length) * fontSize) +
                    radius,
                -(_state.bubblesList[i].yOffset / 2 + radius) + fontSize),
          );
        }
      }
    }

    canvas.rotate(angle);

    canvas.rotate(-angle);

    canvas.restore();
  }

  // This is called when user start drag.
  void _onDragStart(DragStartDetails details) {
    if (!_active) {
      if (onChangeStart != null) onChangeStart!(_value);
      Rect _trackRect = _getTrackRect();
      _currentDragValue =
          ((globalToLocal(details.globalPosition).dx - _trackRect.left) /
              _trackRect.width);
      _value = _currentDragValue.clamp(0.0, 1.0);
      onChanged(_value * 100);

      _state.animationEndTimer?.cancel();
      _state.animationController.repeat();
      _active = true;
    }
  }

  /// This is called when slider values change.
  void _onDragUpdate(DragUpdateDetails details) {
    if (_active) {
      Rect _trackRect = _getTrackRect();
      _currentDragValue += details.primaryDelta! / _trackRect.width;
      final progress = _currentDragValue.clamp(0.0, 1.0);
      if (_value != progress) {
        _value = progress;
      }
      onChanged(_value * 100);
    }
  }

  void _onDragEnd(DragEndDetails details) => _handleDragEnd();

  void _onDragCancel() => _handleDragEnd();

  void _handleDragEnd() {
    if (_active && _state.mounted) {
      if (onChangeEnd != null) onChangeEnd!(_value);
    }
  }

  Rect _getTrackRect({Offset offset = Offset.zero, double progress = 1.0}) =>
      Rect.fromLTWH(
          offset.dx + _thumbRadius,
          offset.dy + (size.height - _trackHeight) / 2,
          (size.width - _thumbRadius * 2) * progress,
          _trackHeight);

  Rect _getBalloonRect(
          {Offset offset = Offset.zero,
          Size parentSize = const Size(0.0, 0.0)}) =>
      Rect.fromLTWH(
          offset.dx,
          offset.dy - ((_bubbleHeight - parentSize.height) / 2) - 10,
          _bubbleWidth,
          _bubbleHeight);

  Rect _getThumbRect({Offset offset = Offset.zero}) =>
      Rect.fromCircle(center: offset, radius: _thumbRadius);

  void _buildPaints() {
    _trackPaint = Paint()..color = _color.withOpacity(0.25);
    _progressPaint = Paint()..color = _color;
    _thumbPaint = Paint()..color = _color;
  }

  @override
  void performResize() {
    size = Size(
        constraints.hasBoundedWidth
            ? constraints.maxWidth
            : _minWidth + _thumbRadius,
        constraints.hasBoundedHeight
            ? constraints.maxHeight
            : _minHeight + _thumbRadius * 2);
  }

  @override
  double computeMinIntrinsicWidth(double height) => _minWidth + _thumbRadius;

  @override
  double computeMaxIntrinsicWidth(double height) => _minWidth + _thumbRadius;

  @override
  double computeMinIntrinsicHeight(double width) =>
      _minHeight + _thumbRadius * 2;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _minHeight + _thumbRadius * 2;

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }
}
