import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class SkewedButtonElevated extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double width;
  final double height;
  final Color color;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const SkewedButtonElevated({
    super.key,
    this.onPressed,
    required this.child,
    this.height = 50,
    this.width = 60,
    this.color = const Color(0xFFFF990A),
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.border,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
    this.foregroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.all(4.0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Transform(
        transform: vm.Matrix4.skewX(-0.2),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            border: border,
            boxShadow: boxShadow,
          ),
          padding: padding,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(color: foregroundColor),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}