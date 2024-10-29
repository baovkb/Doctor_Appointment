import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:flutter/material.dart';

class AvailableScheduleCart extends StatelessWidget {
  final Color bgColor;
  final Color mainTextColor;
  final Color secondaryTextColor;
  final BaseButton button;
  final DoctorModel doctor;
  final ScheduleModel schedule;
  final LocationModel location;
  final SpecialistModel specialist;

  const AvailableScheduleCart({
    super.key, 
    required this.bgColor,
    required this.mainTextColor, 
    required this.secondaryTextColor,
    required this.button,
    required this.doctor, 
    required this.schedule, 
    required this.location, 
    required this.specialist});

  @override
  Widget build(BuildContext context) {
    List<String> startTimeSp = schedule.start_time.split(' ');
    List<String> endTimeSp = schedule.end_time.split(' ');

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.white),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(doctor.photoURL??AppImages.defaultAvatar)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name, style: AppTextStyles.body2Semi!.copyWith(color: mainTextColor)),
                  Text(
                    '${specialist.name} | ${location.name}', 
                    style: AppTextStyles.body2Regular!.copyWith(color: secondaryTextColor, height: 1.6),),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(AppIcons.time, color: mainTextColor,),
                      SizedBox(width: 8,),
                      Text('${startTimeSp[0]} - ${endTimeSp[0]}', style: AppTextStyles.body2Medium!.copyWith(color: mainTextColor),)
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 16,),
          Center(child: button)
        ],
      ));
  }
}