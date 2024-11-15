import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:doctor_appointment/presentation/blocs/upcoming_appointment_cubit.dart';

import 'package:doctor_appointment/presentation/blocs/user_apppointment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class UpcomingAppointmentCard extends StatefulWidget {
 
  const UpcomingAppointmentCard({super.key});

  @override
  State<UpcomingAppointmentCard> createState() => _UpcomingAppointmentCardState();
}

class _UpcomingAppointmentCardState extends State<UpcomingAppointmentCard> {
  @override
  void initState() {
    super.initState();

    Provider.of<UpComingAppointmentCubit>(context, listen: false).getUpcomingAppointment();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpComingAppointmentCubit, GetUpcomingAppoinmentState>(
      builder: (context, state) {
        if (state is GetUpcomingAppointmentLoading || state is GetUpcomingAppointmentInitial) {
          return Center(child: CircularProgressIndicator(),);
        } else if (state is GetUpcomingAppointmentSuccess) {
          return SizedBox(
            height: state.appointmentList.length == 0 ? 0 : 132,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 16,),
              itemCount: state.appointmentList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var time = state.scheduleList[index].start_time.split(' ');
                List<String> tmp = time[1].split('/');
                String date = '${tmp[0]}/${tmp[1]}'; 

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.APPOINTMENT_DETAIL, arguments: {
                      'doctor': state.doctorList[index],
                      'schedule': state.scheduleList[index],
                      'appointment': state.appointmentList[index],
                      'location': state.locationList[index],
                      'specialist': state.specialistList[index]
                    });
                  },
                  child: Container(
                    width: 218,
                    height: 132,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                border: Border.all(width: 1, color: Colors.white),
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(state.doctorList[index].photoURL??AppImages.defaultAvatar)),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.doctorList[index].name, 
                                        style: AppTextStyles.body2Semi!.copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        state.specialistList[index].name, 
                                        style: AppTextStyles.body2Semi!.copyWith(color: AppColors.shadowText),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Text('${state.doctorList[index].star}', style: AppTextStyles.body2Medium!.copyWith(color: Colors.white),),
                                        Image.asset(AppIcons.star)
                                      ],)
                                    ],
                                  ),
                                  Image.asset(
                                    AppIcons.kebab,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AppIcons.calendar),
                                SizedBox(width: 8,),
                                Text(date, style: AppTextStyles.body2Semi?.copyWith(color: Colors.white)),
                              ],
                            )),
                            Expanded(child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AppIcons.time),
                                SizedBox(width: 8,),
                                Text(time[0], style: AppTextStyles.body2Semi?.copyWith(color: Colors.white))
                              ],
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          );
        } else {
          return Center(child: Text('error'),);
        }
      }
    );
  }
}