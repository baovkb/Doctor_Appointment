import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:flutter/material.dart';

class BigSecondaryButton extends BaseButton {
  BigSecondaryButton({
    super.key,
    super.onPress,
    required super.child
  });
  
  @override
  Size get buttonSize => const Size(327, 56);

  @override
  double get fontSize => 16;

  @override
  Color get backgroundColor => AppColors.buttonBg;
  
  @override
  Color get foregroundColor => AppColors.primaryColor;
}
