import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/presentation/widgets/xs_primary_button.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String? message;
  final String textButton;
  final VoidCallback? onButtonTap;

  const SuccessDialog({super.key, this.message, required this.textButton, this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                AppIcons.check64, 
                width: 32,
                height: 32,
                color: AppColors.primaryColor,),
            ),
            Text(AppStrings.success, style: Theme.of(context).textTheme.headlineSmall,),
            message != null 
            ? Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(message!, 
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,))
            : const SizedBox(height: 12,),
            XsPrimaryButton(
              onPress: () {
                Navigator.pop(context);
                onButtonTap?.call();
              },
              child: Text(textButton,))
          ],
        ),),
    );
  }
}