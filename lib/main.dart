import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _activeColor = const Color.fromARGB(255, 157, 0, 255);
  double _sliderValue = 6.0;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfSliderTheme(
        data: SfSliderThemeData(
          activeTrackColor: _activeColor.withOpacity(0.5),
          thumbColor: Colors.transparent,
          overlayColor: _activeColor.withOpacity(0.1),
          overlayRadius: 35,
          activeTrackHeight: 18,
          inactiveTrackHeight: 18,
          inactiveTrackColor: _activeColor.withOpacity(0.1),
        ),
        child: SfSlider(
          max: 10.0,
          value: _sliderValue,
          onChanged: (dynamic value) {
            setState(() {
              if (value <= _sliderValue) {
                _sliderValue = value as double;
                _isActive = false;
              } else {
                _sliderValue = value as double;
                _isActive = true;
              }
            });
          },
          interval: 1,
          showDividers: true,
          thumbShape: _RectThumbShape(_activeColor, _isActive),
          dividerShape: _DividerShape(_activeColor),
        ),
      ),
    );
  }
}

class _DividerShape extends SfDividerShape {
  _DividerShape(this._activecolor);

  final Color _activecolor;

  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    bool isActive;
    switch (textDirection) {
      case TextDirection.ltr:
        isActive = center.dx <= thumbCenter!.dx;
        break;
      case TextDirection.rtl:
        isActive = center.dx >= thumbCenter!.dx;
        break;
    }

    Path innerPath = Path()
      ..moveTo(center.dx, center.dy - 7)
      ..lineTo(center.dx + 7, center.dy)
      ..lineTo(center.dx, center.dy + 7)
      ..lineTo(center.dx - 7, center.dy)
      ..close();

    context.canvas.drawPath(
        innerPath,
        Paint()
          ..isAntiAlias = true
          ..color = isActive ? _activecolor : Colors.white
          ..style = PaintingStyle.fill);
  }
}

class _RectThumbShape extends SfThumbShape {
  _RectThumbShape(this._activecolor, this._isActive);

  final bool _isActive;
  final Color _activecolor;

  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required RenderBox? child,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required SfThumb? thumb}) {
    super.paint(context, center,
        parentBox: parentBox,
        child: child,
        themeData: themeData,
        currentValue: currentValue,
        paint: paint,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumb: thumb);

    final arrowPathRight = Path()
      ..moveTo(center.dx - 13, center.dy - 13) // Starting point (left side)
      ..lineTo(center.dx + 17, center.dy) // Tip of the arrow (right side)
      ..lineTo(center.dx - 13, center.dy + 13) // Bottom left corner
      ..lineTo(center.dx - 7, center.dy) // Middle left to complete the arrow
      ..close();

    final arrowPathLeft = Path()
      ..moveTo(
          center.dx + 13, center.dy - 13) // Starting point (top right side)
      ..lineTo(center.dx - 17, center.dy) // Tip of the arrow (left side)
      ..lineTo(center.dx + 13, center.dy + 13) // Bottom right corner
      ..lineTo(center.dx + 7, center.dy) // Middle right to complete the arrow
      ..close();

    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final Paint activePaint = Paint()
      ..color = _activecolor
      ..style = PaintingStyle.fill;

    context.canvas.drawCircle(center, 25, activePaint);

    if (_isActive) {
      context.canvas.drawPath(arrowPathRight, fillPaint);
    } else {
      context.canvas.drawPath(arrowPathLeft, fillPaint);
    }
  }
}
