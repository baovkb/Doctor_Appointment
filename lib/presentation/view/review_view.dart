// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/presentation/blocs/add_review_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:flutter/material.dart';

import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/review_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewView extends StatefulWidget {
  final DoctorModel doctorModel;
  final SpecialistModel specialistModel;
  final LocationModel locationModel;
  final ScheduleModel scheduleModel;
  final AppointmentModel appointmentModel;
  final ReviewModel? review;

  const ReviewView({
    Key? key,
    required this.doctorModel,
    required this.specialistModel,
    required this.locationModel,
    required this.scheduleModel,
    required this.appointmentModel,
    this.review,
  }) : super(key: key);

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  late final Color _mainTextColor;
  late final Color _secondaryTextColor;
  late final Color _foregroundColor;
  late final TextEditingController _reviewController;
  late final bool _viewMode;
  late double rate;

  @override
  void initState() {
    super.initState();

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _mainTextColor = AppColors.blackColor;
      _foregroundColor = AppColors.gray4;
    } else {
      _mainTextColor = AppColors.darkWhite;
      _foregroundColor = AppColors.darkFg;
    }
    _secondaryTextColor = AppColors.gray1;
    _reviewController = TextEditingController();
    _viewMode = widget.appointmentModel.review_id != null && widget.review != null;
    
    if (_viewMode) {
      rate = widget.review!.star;
      _reviewController.text = widget.review!.review??' ';
    } else {
      rate = 0;
      _reviewController.text = '';
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddReviewCubit, AddReviewState>(
      listener: (context, state) {
        if (state is AddReviewSuccess) {
          Navigator.popAndPushNamed(context, RouteName.REVIEW, arguments: {
            'doctor': state.doctor,
            'specialist': widget.specialistModel,
            'location': widget.locationModel,
            'schedule': widget.scheduleModel,
            'appointment': state.appointment,
            'review': state.review
          });
        }
      },
      child: Scaffold(
        body: SafeArea(child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 34),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(AppIcons.back, color: _mainTextColor,)),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _viewMode ? AppStrings.readReviewTitle : AppStrings.writeReviewTitle, 
                        textAlign: TextAlign.center, style: AppTextStyles.bodyBold,
                      )
                    ),
                    Spacer()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 34),
                      alignment: Alignment.center,
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _secondaryTextColor
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        widget.doctorModel.photoURL??AppImages.defaultAvatar,
                        fit: BoxFit.contain,),
                    ),
                    Text(
                      _viewMode ? AppStrings.ratedMsg : AppStrings.rateMsg, 
                      style: AppTextStyles.body2Regular!.copyWith(color: _mainTextColor),
                    ),
                    Text(widget.doctorModel.name, style: AppTextStyles.bodyBold!.copyWith(color: AppColors.primaryColor),),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: PannableRatingBar(
                        minRating: 1,
                        maxRating: 5,
                        rate: rate,
                        items: List.generate(
                          5, 
                          (index) => const RatingWidget(
                            selectedColor: Colors.yellow,
                            unSelectedColor: Colors.grey,
                            child: Icon(
                              Icons.star,
                              size: 28,
                            ),
                          )
                        ),
                        onChanged: (value) {
                          if (_viewMode) return;
                          setState(() {
                            rate = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.writeReview, style: AppTextStyles.bodySemi!.copyWith(color: _mainTextColor),),
                    SizedBox(height: 16,),
                    TextField(
                      readOnly: _viewMode,
                      minLines: 5,
                      maxLines: 5,
                      controller: _reviewController,
                      decoration: InputDecoration(
                        hintText: AppStrings.writeReviewHint,
                        hintStyle: AppTextStyles.body2Medium!.copyWith(color: _secondaryTextColor),
                        filled: true,
                        fillColor: _foregroundColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)
                        )
                      ),
                    ) 
                  ],
                ),
              ),
              SizedBox(height: 16,),
              if (!_viewMode) Center(child: BigPrimaryButton(
                onPress: () {
                  Provider.of<AddReviewCubit>(context, listen: false).addReview(
                    appointment_id: widget.appointmentModel.id, 
                    star: rate, 
                    review: _reviewController.text, 
                    doctor_id: widget.doctorModel.id);
                },
                child: Text(AppStrings.submitReview)),)
            ],
          ),
        )),
      ),
    );
  }
}