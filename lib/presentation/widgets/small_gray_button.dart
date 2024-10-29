import 'dart:ui';

import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:flutter/material.dart';

class SmallGrayButton extends BaseButton{
  SmallGrayButton({
    super.key,
    super.onPress,
    required super.child
  });

  @override
  Color get backgroundColor => AppColors.grayBgBtn;

  @override
  Size get buttonSize => const Size(295, 40);

  @override
  double get fontSize => 14;

  @override
  Color get foregroundColor => Colors.white;

}