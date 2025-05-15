// lib/widgets/custom_button_elevated.dart
import 'package:flutter/material.dart';

class CustomButtonElevated extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final Color foregroundColor;
  final OutlinedBorder? customShape;
  final BorderSide? borderSide;

  const CustomButtonElevated({
    Key? key,
    required this.text,
    this.onPressed,
    this.width = 200,
    this.height = 50,
    this.textStyle,
    this.backgroundColor = const Color.fromARGB(188, 255, 153, 0),
    this.foregroundColor = Colors.black,
    this.customShape,
    this.borderSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: customShape,
          side: borderSide,
          padding: EdgeInsets.all(9.0),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle ?? TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}


class TrapezoidShape extends OutlinedBorder {
  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return TrapezoidShape();
  }
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    path.moveTo(rect.left, rect.top + rect.height * 0.1);
    path.lineTo(rect.left + rect.width * 0, rect.top);
    path.lineTo(rect.left + rect.width * 1, rect.top);
    path.lineTo(rect.right, rect.top + rect.height * 0.5);
    path.lineTo(rect.right, rect.bottom - rect.height * 1);
    path.lineTo(rect.left + rect.width * 0.85, rect.bottom);
    path.lineTo(rect.left + rect.width * 0.5, rect.bottom);
    path.lineTo(rect.left, rect.bottom - rect.height * 0);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {BorderSide borderSide = BorderSide.none, TextDirection? textDirection}) {
    final paint = borderSide.toPaint();
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  TrapezoidShape scale(double t) => this;
}