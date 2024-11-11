// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/review_model.dart';
import 'package:doctor_appointment/presentation/widgets/small_gray_button.dart';
import 'package:doctor_appointment/presentation/widgets/small_primary_button.dart';
import 'package:flutter/material.dart';

import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';

class BookedAppointmentCard extends StatefulWidget {
  final DoctorModel doctor;
  final SpecialistModel specialist;
  final LocationModel location;
  final ScheduleModel schedule;
  final AppointmentModel appointment;
  final ReviewModel? review;
  final void Function(
    DoctorModel doctor, 
    ScheduleModel schedule, 
    LocationModel location, 
    SpecialistModel specialist,
    AppointmentModel appointment,
    ReviewModel? review
  )? onCardTap;
  final void Function(
    DoctorModel doctor, 
    ScheduleModel schedule, 
    LocationModel location, 
    SpecialistModel specialist,
    AppointmentModel appointment,
    ReviewModel? review
  )? onReviewTap;
  final Color bgColor;
  final Color mainTextColor;
  final Color secondaryTextColor;
  final bool checkReview;

  const BookedAppointmentCard({
    Key? key,
    required this.doctor,
    required this.specialist,
    required this.location,
    required this.schedule,
    required this.appointment,
    this.review,
    this.onCardTap,
    this.onReviewTap,
    required this.bgColor,
    required this.mainTextColor,
    required this.secondaryTextColor,
    required this.checkReview
  }) : super(key: key);

  @override
  State<BookedAppointmentCard> createState() => _BookedAppointmentCardState();
}

class _BookedAppointmentCardState extends State<BookedAppointmentCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> startTimeSp = widget.schedule.start_time.split(' ');
    List<String> endTimeSp = widget.schedule.end_time.split(' ');

    return GestureDetector(
      onTap: () {
        widget.onCardTap?.call(widget.doctor, widget.schedule, widget.location, widget.specialist, widget.appointment, widget.review);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.bgColor,
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
                      image: NetworkImage(widget.doctor.photoURL??AppImages.defaultAvatar)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.doctor.name, style: AppTextStyles.body2Semi!.copyWith(color: widget.mainTextColor)),
                    Text(
                      '${widget.specialist.name} | ${widget.location.name}', 
                      style: AppTextStyles.body2Regular!.copyWith(color: widget.secondaryTextColor, height: 1.6),),
                    SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(AppIcons.time, color: widget.mainTextColor,),
                        SizedBox(width: 8,),
                        Text('${startTimeSp[0]} - ${endTimeSp[0]}', style: AppTextStyles.body2Medium!.copyWith(color: widget.mainTextColor),),
                        SizedBox(width: 16,),
                        Image.asset(AppIcons.calendar, color: widget.mainTextColor),
                        SizedBox(width: 8,),
                        Text('${startTimeSp[1]}', style: AppTextStyles.body2Medium!.copyWith(color: widget.mainTextColor),)
                      ],
                    ),
                    SizedBox(height: 8,),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('${widget.doctor.star}', style: AppTextStyles.body2Semi!.copyWith(color: widget.mainTextColor),),
                    Image.asset(AppIcons.star),
                  ],),
                )
              ],
            ),
            if (widget.checkReview) Center(
              child: widget.appointment.review_id == null 
                ? SmallPrimaryButton(
                  onPress: () {
                    widget.onReviewTap?.call(widget.doctor, widget.schedule, widget.location, widget.specialist, widget.appointment, widget.review);
                  },
                  child: Text(AppStrings.review, style: AppTextStyles.body2Semi!.copyWith(color: Colors.white),))
                : SmallGrayButton(
                    onPress: () {
                      widget.onReviewTap?.call(widget.doctor, widget.schedule, widget.location, widget.specialist, widget.appointment, widget.review);
                    },
                    child: PannableRatingBar(
                    rate: widget.review!.star,
                    items: List.generate(5, (index) =>
                      const RatingWidget(
                        selectedColor: Colors.yellow,
                        unSelectedColor: Colors.grey,
                        child: Icon(
                          Icons.star,
                          size: 18,
                        ),
                      )
                    ),
                  ),
                ),
            )
          ],
        )),
    ); 
  }
}