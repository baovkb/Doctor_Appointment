import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/presentation/blocs/get_doctors_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final Color _mainTextColor;
  late final Color _secondaryTextColor;

  @override
  void initState() {
    super.initState();

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _mainTextColor = AppColors.blackColor;
      _secondaryTextColor = AppColors.gray1;
    } else {
      _mainTextColor = AppColors.darkWhite;
      _secondaryTextColor = AppColors.gray2;
    }

    Provider.of<GetDoctorsCubit>(context, listen: false).getDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 32),
            padding: EdgeInsets.symmetric(horizontal: 24),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(AppIcons.search, color: _mainTextColor,),
                SizedBox(width: 12,),
                Image.asset(AppIcons.setting, color: _mainTextColor,)
            ],),
          ),
          BlocBuilder<GetDoctorsCubit, GetDoctorsState>(
            builder: (_, state) {
              if (state is GetDoctorsInitial || state is GetDoctorsLoading) {
                return Center(child: CircularProgressIndicator(color: _mainTextColor, strokeWidth: 2,),);
              } else if (state is GetDoctorsSuccess) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.doctors.length,
                    itemBuilder: (_, index) {
                      return ContactItem(
                        doctor: state.doctors[index], 
                        specialist: state.specialists[index], 
                        mainTextColor: _mainTextColor, 
                        secondaryTextColor: _secondaryTextColor,
                        onItemTap: (doctor, specialist) {
                          Navigator.pushNamed(context, RouteName.CONVERSATION, arguments: {
                            'doctor': doctor
                          });
                        },);
                    }, 
                    separatorBuilder: (_, i) => SizedBox(height: 16,),
                    ),
                );
              } else {
                return Text('error: ${state}');
              }
            },
          )
        ],
      )),
    );
  }
}