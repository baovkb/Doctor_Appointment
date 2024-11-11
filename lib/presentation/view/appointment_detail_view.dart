import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/presentation/blocs/add_appointment_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:doctor_appointment/presentation/widgets/success_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AppointmentDetailView extends StatefulWidget {
  final DoctorModel doctorModel;
  final SpecialistModel specialistModel;
  final LocationModel locationModel;
  final ScheduleModel scheduleModel;
  final AppointmentModel? appointmentModel;
  final bool viewMode;
  
  AppointmentDetailView({
    super.key,
    required this.doctorModel,
    required this.specialistModel,
    required this.locationModel,
    required this.scheduleModel,
    this.viewMode = true,
    this.appointmentModel
  }) {
    if (this.viewMode) {
      assert (appointmentModel != null);
    }
  }

  @override
  State<AppointmentDetailView> createState() => _AppointmentDetailViewState();
}

class _AppointmentDetailViewState extends State<AppointmentDetailView> {
  late final Color _mainTextColor;
  late final Color _cardBgColor;
  late final Color _secondaryTextColor;
  late final TextEditingController _messageController;
  late final AddAppointmentCubit _addAppointmentCubit;

  @override
  void initState() {
    super.initState();

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _mainTextColor = AppColors.blackColor;
      _cardBgColor = AppColors.gray4;
    } else {
      _mainTextColor = AppColors.darkWhite;
      _cardBgColor = AppColors.darkFg;
    }

    _secondaryTextColor = AppColors.gray1;
    _messageController = TextEditingController();
    if (widget.viewMode) {
      _messageController.text = widget.appointmentModel!.message??' ';
    }

    _addAppointmentCubit = Provider.of<AddAppointmentCubit>(context, listen: false);
  }

  @override
  void dispose() {
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startTimeSplit = widget.scheduleModel.start_time.split(' ');
    final endTimeSplit = widget.scheduleModel.end_time.split(' ');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    child: Text(AppStrings.appointmentDetailTitle, textAlign: TextAlign.center, style: AppTextStyles.bodyBold,)),
                  Spacer()
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardBgColor,
                borderRadius: BorderRadius.circular(16)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.doctorModel.photoURL??AppImages.defaultAvatar),
                        fit: BoxFit.contain)
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.doctorModel.name, style: AppTextStyles.body2Semi!.copyWith(color: _mainTextColor),),
                            Row(children: [
                              Text('${widget.doctorModel.star}', style: AppTextStyles.body2Semi,),
                              Image.asset(AppIcons.star)
                            ],)
                          ],
                        ),
                        Text('${widget.specialistModel.name} | ${widget.locationModel.name}', 
                          style: AppTextStyles.bodyRegular!.copyWith(
                            height: 1.6,
                            color: _secondaryTextColor),),
                        
                      ],
                    ),
                  )
              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24,),
                  Text(AppStrings.schedule, style: AppTextStyles.h3Bold!.copyWith(color: _mainTextColor),),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 152,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _cardBgColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(children: [
                          Text(startTimeSplit[1], style: AppTextStyles.bodyBold!.copyWith(color: _mainTextColor),),
                          Text(AppStrings.date, style: AppTextStyles.bodyMedium!.copyWith(color: _secondaryTextColor),)
                        ],),
                      ),
                      SizedBox(width: 24,),
                      Container(
                        width: 152,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _cardBgColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(children: [
                          Text('${startTimeSplit[0]} - ${endTimeSplit[0]}', style: AppTextStyles.bodyBold!.copyWith(color: _mainTextColor),),
                          Text(AppStrings.time, style: AppTextStyles.bodyMedium!.copyWith(color: _secondaryTextColor),)
                        ],),
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 152,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _cardBgColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(children: [
                          Text(widget.scheduleModel.price.toString(), style: AppTextStyles.bodyBold!.copyWith(color: _mainTextColor),),
                          Text(AppStrings.price, style: AppTextStyles.bodyMedium!.copyWith(color: _secondaryTextColor),)
                        ],),
                      ),
                      SizedBox(width: 24,),
                      Container(
                        width: 152,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _cardBgColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Column(children: [
                          Text(widget.locationModel.name, style: AppTextStyles.bodyBold!.copyWith(color: _mainTextColor),),
                          Text(AppStrings.location, style: AppTextStyles.bodyMedium!.copyWith(color: _secondaryTextColor),)
                        ],),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.message, style: AppTextStyles.h3Bold!.copyWith(color: _mainTextColor)),
                  SizedBox(height: 24,),
                  TextField(
                    minLines: 5,
                    maxLines: 5,
                    readOnly: widget.viewMode,
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: AppStrings.hintTextMsgForDoctor,
                      hintStyle: AppTextStyles.body2Medium!.copyWith(color: _secondaryTextColor),
                      filled: true,
                      fillColor: _cardBgColor,
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
            SizedBox(height: 24,),
            if (!widget.viewMode)
              Center(child: BlocConsumer<AddAppointmentCubit, AddAppointmentState>(
                listener: (context, state) {
                  if (state is AddAppointmentFailure) {
                    debugPrint(state.message);
                  } else if (state is AddAppointmentSuccess) {
                    showDialog(
                      barrierDismissible: false,
                      context: context, 
                      builder: (_) {
                        return SuccessDialog(
                          message: AppStrings.bookSuccess, 
                          textButton: AppStrings.continueAction,
                          onButtonTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, RouteName.HOME_PAGE, (_) => false);
                          },
                        );
                      }
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AddAppointmentLoading) {
                    return BigPrimaryButton(child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,));
                  } else {
                    return BigPrimaryButton(
                      child: Text(AppStrings.bookAppoimentAction),
                      onPress: () {
                        _addAppointmentCubit.addAppointment(
                          schedule_id: widget.scheduleModel.id, 
                          uid: FirebaseAuth.instance.currentUser!.uid, 
                          message: _messageController.text,
                          status: AppointmentStatus.pending);
                      },
                    );
                  }
                },
              ),),
          ],),
        )
      ),
    );
  }
}