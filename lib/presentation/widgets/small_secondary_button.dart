import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:flutter/material.dart';

import '../../core/resources/colors.dart';
import '../../core/resources/fonts.dart';

class SmallSecondaryButton extends BaseButton {

  SmallSecondaryButton({
    super.key,
    super.onPress,
    required super.child
  });
  
  @override
  Color get backgroundColor => AppColors.buttonBg;
  
  @override
  Size get buttonSize => const Size(295, 40);
  
  @override
  double get fontSize => 14;
  
  @override
  Color get foregroundColor => AppColors.primaryColor;
}