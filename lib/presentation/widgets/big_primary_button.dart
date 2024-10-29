import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/fonts.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:flutter/material.dart';

class BigPrimaryButton extends BaseButton{
  @override
  Size get buttonSize => const Size(327, 56);

  @override
  double get fontSize => 16;

  @override
  Color get backgroundColor => AppColors.primaryColor;

  @override
  Color get foregroundColor => AppColors.whiteColor;

  BigPrimaryButton({
    super.key,
    super.onPress,
    required super.child
  });

}