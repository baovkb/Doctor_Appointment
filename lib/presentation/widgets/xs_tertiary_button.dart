import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:flutter/material.dart';

import '../../core/resources/fonts.dart';

class XsTertiaryButton extends BaseButton {
  XsTertiaryButton({
    super.key,
    super.onPress,
    required super.child
  });
  
  @override
  Color get backgroundColor => Colors.transparent;
  
  @override
  Size get buttonSize => const Size(104, 40);
  
  @override
  double get fontSize => 14;
  
  @override
  Color get foregroundColor => AppColors.primaryColor;
}
