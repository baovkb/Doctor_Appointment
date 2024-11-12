// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:flutter/material.dart';

import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';

class ContactItem extends StatelessWidget {
  final DoctorModel doctor;
  final SpecialistModel specialist;
  final Color mainTextColor;
  final Color secondaryTextColor;
  final void Function(DoctorModel doctor, SpecialistModel specialist)? onItemTap;

  const ContactItem({
    Key? key,
    required this.doctor,
    required this.specialist,
    required this.mainTextColor,
    required this.secondaryTextColor,
    this.onItemTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemTap?.call(doctor, specialist);
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            onItemTap?.call(doctor, specialist);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  doctor.photoURL??AppImages.defaultAvatar),
              ),
              SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: AppTextStyles.bodyBold!.copyWith(color: mainTextColor),),
                  Text(specialist.name, style: AppTextStyles.bodyRegular!.copyWith(color: secondaryTextColor),)
                ],
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(AppIcons.voiceCall, color: mainTextColor,),
                    SizedBox(width: 24,),
                    Image.asset(AppIcons.videoCall, color: mainTextColor,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
