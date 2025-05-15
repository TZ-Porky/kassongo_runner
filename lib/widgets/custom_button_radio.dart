import 'package:flutter/material.dart';

class CustomButtonRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Color activeColor;
  final Color borderColor;

  const CustomButtonRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.activeColor = const Color.fromARGB(188, 255, 153, 0),
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      child: Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          color:  Color.fromARGB(120, 0, 0, 0),
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 3.5,
          ),
        ),
        child: Center(
          child: value == groupValue
              ? Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
