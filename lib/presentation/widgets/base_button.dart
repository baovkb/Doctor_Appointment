import 'package:doctor_appointment/core/resources/fonts.dart';
import 'package:flutter/material.dart';

abstract class BaseButton extends StatelessWidget {
  VoidCallback? onPress;
  final Widget child;

  Size get buttonSize;
  double get fontSize;
  Color get backgroundColor;
  Color get foregroundColor;

  BaseButton({super.key, this.onPress, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(foregroundColor),
          textStyle: WidgetStatePropertyAll(TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            fontFamily: AppFonts.primaryFont,
            color: foregroundColor
          ),),
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          foregroundColor: WidgetStatePropertyAll(foregroundColor),
          minimumSize: WidgetStatePropertyAll(buttonSize),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32)
          ))
        ),
        child: child
    );
  }
}