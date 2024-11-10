import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/presentation/blocs/schedules_by_ids_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/select_schedule_notifier.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DoctorInforView extends StatefulWidget {
  final DoctorModel doctorModel;
  final SpecialistModel specialistModel;
  final LocationModel locationModel;
  final ScheduleModel? scheduleModel;

  const DoctorInforView({
    super.key, 
    required this.doctorModel,
    required this.specialistModel,
    required this.locationModel,
    this.scheduleModel
  });

  @override
  State<DoctorInforView> createState() => _DoctorInforViewState();
}

class _DoctorInforViewState extends State<DoctorInforView> {
  late final Color _cardBgColor;
  late final Color _mainTextColor;
  late final Color _secondaryTextColor;
  late final SelectScheduleNotifier _selectNotifer;

  @override
  void initState() {
    super.initState();

    _selectNotifer = SelectScheduleNotifier();
    if (widget.scheduleModel != null)
      _selectNotifer.setSelectedSchedule(widget.scheduleModel!);

    if (widget.doctorModel.schedule_id != null)
      Provider.of<SchedulesByIDsCubit>(context, listen: false).getAvailableSchedulesByIDs(widget.doctorModel.schedule_id!);

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _cardBgColor = AppColors.whiteColor;
      _mainTextColor = AppColors.blackColor;
    } else {
      _cardBgColor = AppColors.darkFg;
      _mainTextColor = AppColors.darkWhite;
    }

    _secondaryTextColor = AppColors.gray1;
  }

  @override
  void dispose() {
    _selectNotifer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectScheduleNotifier>(
      create: (_) => _selectNotifer,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 34,
                left: 0,
                right: 0,
                child: Container(
                  // margin: EdgeInsets.only(top: 34),
                  height: 270,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.doctorModel.photoURL??AppImages.defaultAvatar),
                      fit: BoxFit.contain)
                  ),
                ),
              ),
              _buildInfoCard(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 34),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(AppIcons.back, color: _mainTextColor,)),
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: Text(AppStrings.doctorInfoTitle, textAlign: TextAlign.center, style: AppTextStyles.bodyBold,)),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 285 - 40),
        margin: EdgeInsets.only(top: 285),
        padding: EdgeInsets.only(bottom: 40, left: 24, right: 24),
        decoration: BoxDecoration(
          color: _cardBgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(
              width: 64,
              height: 4,
              margin: EdgeInsets.only(top: 16, bottom: 32),
              decoration: BoxDecoration(
                color: _mainTextColor,
                borderRadius: BorderRadius.circular(8)
            ),),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.doctorModel.name}', style: AppTextStyles.h3Bold,),
                    Row(children: [
                      Text('${widget.doctorModel.star}', style: AppTextStyles.body2Semi,),
                      Image.asset(AppIcons.star)
                    ],)
                  ],
                ),
                Text('${widget.specialistModel.name} | ${widget.locationModel.name}', 
                style: AppTextStyles.bodyRegular!.copyWith(
                  height: 1.6,
                  color: _secondaryTextColor),)
              ],
            ),
            SizedBox(height: 24,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('${AppStrings.description}', style: AppTextStyles.h3Bold,),
              Text('${widget.doctorModel.description}', 
              style: AppTextStyles.body2Regular!.copyWith(
                height: 1.6
              ),)
            ],),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                height: 1,
                color: _secondaryTextColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppStrings.schedules}', style: AppTextStyles.h3Bold,),
                SizedBox(height: 16,),
                BlocBuilder<SchedulesByIDsCubit, GetSchedulesByIDsState>(
                  builder: (_, state) {
                    if (state is GetAvailableSchedulesByIDsSuccess) {

                      return Consumer<SelectScheduleNotifier>(
                        builder: (_, value, child) { 
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: List.generate(
                              state.schedules.length, 
                              (index) {
                                final startTimeArr = state.schedules[index].start_time.split(' ');
                                final endTimeArr = state.schedules[index].end_time.split(' ');
                          
                                return GestureDetector(
                                  onTap: () => _selectNotifer.setSelectedSchedule(state.schedules[index]),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _selectNotifer.selectedSchedule != null && _selectNotifer.selectedSchedule == state.schedules[index] ? AppColors.primaryColor : _secondaryTextColor),
                                      borderRadius: BorderRadius.circular(32)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Time: ${startTimeArr[0]} - ${endTimeArr[0]} ${startTimeArr[1]}'),
                                        Text('Price: ${state.schedules[index].price}')
                                      ],
                                    ),
                                  ),
                                );
                              } 
                            ),
                          );
                        },
                      );
                    } else return SizedBox();
                  },
                ),
                SizedBox(height: 40,),
                Center(child: BigPrimaryButton(
                  onPress: () => Navigator.pushNamed(
                    context, 
                    RouteName.APPOINTMENT_DETAIL,
                    arguments: {
                      'doctor': widget.doctorModel,
                      'schedule': _selectNotifer.selectedSchedule,
                      'location': widget.locationModel,
                      'specialist': widget.specialistModel
                    }),
                  child: Text(AppStrings.bookAppoimentAction)))
              ],
            )
          ],
        ),  
      ),
    );
  }
}