import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/presentation/blocs/user_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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

    Provider.of<UserCubit>(context, listen: false).getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 32),
                padding: EdgeInsets.symmetric(horizontal: 24),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topRight,
                child: Image.asset(AppIcons.kebab, color: _mainTextColor,)
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _secondaryTextColor, width: 1),
                        image: DecorationImage(
                          image: NetworkImage(state.user.photoURL??AppImages.defaultAvatar),
                          fit: BoxFit.contain)
                      ),
                    ),
                    SizedBox(width: 16,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.user.name??AppStrings.unknown, style: AppTextStyles.bodyBold!.copyWith(color: _mainTextColor),),
                        Text(state.user.email??AppStrings.unknown, style: AppTextStyles.bodyRegular!.copyWith(color: _secondaryTextColor),),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: AppColors.darkFg2,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),    
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Image.asset(AppIcons.bell, color: AppColors.primaryColor,)
                    ),
                    SizedBox(width: 18,),
                    Expanded(child: Text(AppStrings.notification, style: AppTextStyles.bodyRegular!.copyWith(color: _mainTextColor),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Image.asset(AppIcons.forward, color: AppColors.primaryColor,),
                    )
                ],),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: AppColors.darkFg2,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),    
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Image.asset(AppIcons.settings_filled, color: AppColors.primaryColor,)
                    ),
                    SizedBox(width: 18,),
                    Expanded(child: Text(AppStrings.setting, style: AppTextStyles.bodyRegular!.copyWith(color: _mainTextColor),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Image.asset(AppIcons.forward, color: AppColors.primaryColor,),
                    )
                ],),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: AppColors.darkFg2,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),    
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Image.asset(AppIcons.help_filled, color: AppColors.primaryColor,)
                    ),
                    SizedBox(width: 18,),
                    Expanded(child: Text(AppStrings.help, style: AppTextStyles.bodyRegular!.copyWith(color: _mainTextColor),)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Image.asset(AppIcons.forward, color: AppColors.primaryColor,),
                    )
                ],),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: AppColors.darkFg2,
                height: 1,
              ),
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamedAndRemoveUntil(context, RouteName.CHECK_MAIL_LOGIN_PAGE, (_) => false);
                      });
                    } 
                  }

                  return GestureDetector(
                    onTap: () {
                      Provider.of<UserCubit>(context, listen: false).signOut();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),    
                            decoration: BoxDecoration(
                              color: AppColors.redColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Image.asset(AppIcons.logout_filled, color: AppColors.redColor,)
                          ),
                          SizedBox(width: 18,),
                          Expanded(child: Text(AppStrings.logout, style: AppTextStyles.bodyRegular!.copyWith(color: _mainTextColor),)),
                      ],),
                    ),
                  );
                },
              )
            ],
          );
        } else if (state is GetUserLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,),);
        } else {
          debugPrint(state.toString());
          return SizedBox();
        }
      },
    )),);
  }
}