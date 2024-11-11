import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/appointment_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/location_model.dart';
import 'package:doctor_appointment/data/models/review_model.dart';
import 'package:doctor_appointment/data/models/schedule_model.dart';
import 'package:doctor_appointment/data/models/specialist_model.dart';
import 'package:doctor_appointment/presentation/blocs/user_apppointment_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/booked_appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  late final Color _mainTextColor;
  late final Color _foregroundColor;
  int _currentTab = 0;

  final List<BookingTab> tabs = [UpcomingTab(), PastTab()];

  @override
  void initState() {
    super.initState();

    Provider.of<UserAppointmentCubit>(context, listen: false).getUserAppointment();

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _mainTextColor = AppColors.blackColor;
      _foregroundColor = AppColors.gray4;
    } else {
      _mainTextColor = AppColors.darkWhite;
      _foregroundColor = AppColors.darkFg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buidTabbar(context),
          tabs[_currentTab]
        ],
      )),
    );
  }

  Container _buidTabbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _foregroundColor,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(children: List.generate(tabs.length, (index) {
          return Expanded(child: GestureDetector(
            onTap: () {
              if (_currentTab != index) {
                setState(() {
                  _currentTab = index;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: _currentTab == index ? Theme.of(context).scaffoldBackgroundColor : _foregroundColor,
                borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.all(4),
              child: Text(tabs[index].TabName, textAlign: TextAlign.center, style: AppTextStyles.bodySemi!.copyWith(color: _mainTextColor),)
            ),
          ));
        }),),
      ),
    );
  }
}

abstract class BookingTab extends StatefulWidget {
  String get TabName;
  bool get useUpcomingRes => true;

  const BookingTab({super.key});
  
  @override
  State<StatefulWidget> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  late final Color _mainTextColor;
  late final Color _secondaryTextColor;
  late final Color _foregroundColor;

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
  }

   @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
          builder: (context, state) {
            if (state is UserAppointmentInitial || state is UserAppointmentLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserAppointmentSuccess) {
              List<Map<String, dynamic>> result = widget.useUpcomingRes ? state.upcomingAppms : state.pastAppms;

              return ListView.separated(
                itemCount: result.length,
                itemBuilder: (context, index) => BookedAppointmentCard(
                  appointment: result[index]['${(AppointmentModel)}'] as AppointmentModel, 
                  doctor: result[index]['${(DoctorModel)}'] as DoctorModel, 
                  specialist: result[index]['${(SpecialistModel)}'] as SpecialistModel, 
                  location: result[index]['${(LocationModel)}'] as LocationModel,
                  schedule: result[index]['${(ScheduleModel)}'] as ScheduleModel, 
                  review: result[index]['${(ReviewModel)}'] as ReviewModel?,
                  bgColor: _foregroundColor, 
                  mainTextColor: _mainTextColor, 
                  secondaryTextColor: _secondaryTextColor,
                  checkReview: !widget.useUpcomingRes,
                  onCardTap: (doctor, schedule, location, specialist, appointment, review) {
                    Navigator.pushNamed(context, RouteName.APPOINTMENT_DETAIL, arguments: {
                      'doctor': doctor,
                      'schedule': schedule,
                      'location': location,
                      'specialist': specialist,
                      'appointment': appointment,
                    });
                  },
                  onReviewTap: (doctor, schedule, location, specialist, appointment, review) {
                    Navigator.pushNamed(context, RouteName.REVIEW, arguments: {
                      'doctor': doctor,
                      'schedule': schedule,
                      'location': location,
                      'specialist': specialist,
                      'appointment': appointment,
                      'review': review
                    });
                  },
                ),
                separatorBuilder: (_, index) {
                  return SizedBox(height: 16,);
                }, 
              );
            } else return Text('error');
          },
        )
      ),
    );
  }
}

class UpcomingTab extends BookingTab {
  const UpcomingTab({super.key});
  
  @override
  String get TabName => AppStrings.upcomingTab;
}

class PastTab extends BookingTab {
  const PastTab({super.key});

  @override
  bool get useUpcomingRes => false;

  @override
  String get TabName => AppStrings.pastTab;
}