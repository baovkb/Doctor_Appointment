import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/fonts.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:doctor_appointment/presentation/blocs/category_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/available_schedule_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/user_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/view/bookings_view.dart';
import 'package:doctor_appointment/presentation/view/chat_view.dart';
import 'package:doctor_appointment/presentation/view/profile_view.dart';
import 'package:doctor_appointment/presentation/view/search_view.dart';
import 'package:doctor_appointment/presentation/widgets/available_schedule_cart.dart';
import 'package:doctor_appointment/presentation/widgets/base_button.dart';
import 'package:doctor_appointment/presentation/widgets/small_gray_button.dart';
import 'package:doctor_appointment/presentation/widgets/small_primary_button.dart';
import 'package:doctor_appointment/presentation/widgets/upcoming_appointment_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final Color _navBarColor;
  late final Color _unselectedLabelColor;
  late final Color _welcomeTextColor;
  late final Color _mainTextColor;
  late final Color _categoryBg;
  late final BaseButton _bookButton;
  int _currentIndexNav = 0;
  late final List<Widget> pageWidgets;

  @override
  void initState() {
    super.initState();

    Provider.of<UserCubit>(context, listen: false).getCurrentUser();
    Provider.of<CategoryCubit>(context, listen: false).getCategories();
    Provider.of<AvailableScheduleCubit>(context, listen: false).getAvailableSchedules(); 

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _navBarColor = AppColors.primaryColor;
      _unselectedLabelColor = AppColors.shadowText;
      _welcomeTextColor = AppColors.gray1;
      _mainTextColor = AppColors.blackColor;
      _categoryBg = AppColors.bg0;
      _bookButton = SmallPrimaryButton(child: Text(AppStrings.bookAppoimentAction));
    } else {
      _navBarColor = AppColors.darkFg;
      _unselectedLabelColor = AppColors.gray1;
      _welcomeTextColor = AppColors.gray2;
      _mainTextColor = AppColors.whiteColor;
      _categoryBg = AppColors.darkFg;
      _bookButton = SmallGrayButton(child: Text(AppStrings.bookAppoimentAction));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    pageWidgets = [
      _buildHomePage(),
      const BookingsView(),
      const ChatView(),
      const ProfileView()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageWidgets.elementAt(_currentIndexNav),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndexNav,
        onTap: (index) {
          setState(() {
            _currentIndexNav = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: _navBarColor,
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.primaryFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedItemColor: _unselectedLabelColor,
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.primaryFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        items: [
          BottomNavigationBarItem(
            activeIcon: Image.asset(AppIcons.homeActive),
            icon: Image.asset(AppIcons.home),
            label: AppStrings.home
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(AppIcons.bookingsActive),
            icon: Image.asset(AppIcons.bookings),
            label: AppStrings.bookings
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(AppIcons.chatActive),
            icon: Image.asset(AppIcons.chat),
            label: AppStrings.chat
          ),
          BottomNavigationBarItem(
            activeIcon: Image.asset(AppIcons.profileActive),
            icon: Image.asset(AppIcons.profile),
            label: AppStrings.profile
          ),
        ]),
    );
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buidTopBar(),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.upComApp, style: AppTextStyles.h3Bold!.copyWith(color: _mainTextColor)),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    child: UpcomingAppointmentCard())
                ],
              ),
            ),
            _buildCategory(),
            _buildBookAppointment()
          ],
        ),
      ),
    );
  }

  Padding _buildBookAppointment() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.bookAppoimentAction, style: AppTextStyles.h3Bold!.copyWith(color: _mainTextColor),),
              Text(AppStrings.seeAll, style: AppTextStyles.bodyMedium!.copyWith(color: _welcomeTextColor),)
            ],
          ),
          SizedBox(height: 24,),
          BlocBuilder<AvailableScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleInitial || state is GetAvailableSchedulesLoading) {
                return Center(child: CircularProgressIndicator(),);
              } else if (state is GetAvailableSchedulesSuccess) {
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16,),
                  itemCount: state.doctorList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), 
                  itemBuilder: (context, index) {
                    return AvailableScheduleCart(
                      bgColor: _categoryBg, 
                      mainTextColor: _mainTextColor, 
                      secondaryTextColor: _welcomeTextColor, 
                      button: _bookButton, 
                      doctor: state.doctorList[index], 
                      schedule: state.scheduleList[index], 
                      location: state.locationList[index], 
                      specialist: state.specialistList[index],
                      onCardTap: (doctor, location, schedule, specialist) {
                        Navigator.pushNamed(context, RouteName.DOCTOR_INFO_PAGE, arguments: {
                          'doctor': state.doctorList[index],
                          'specialist': state.specialistList[index],
                          'location': state.locationList[index],
                          'schedule': state.scheduleList[index]
                        });
                      },);
                });
              } else {
                return Text('error');
              }
            })
        ],
      ), 
    );
  }

  Container _buildCategory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.category, style: AppTextStyles.h3Bold!.copyWith(color: _mainTextColor),),
              Text(AppStrings.seeAll, style: AppTextStyles.bodyMedium!.copyWith(color: _welcomeTextColor),)
            ],
          ),
          BlocBuilder<CategoryCubit, CategoryState>(
            builder:(context, state) {
              if (state is GetCategoriesLoading || state is CategoryInitial) {
                return Center(child: CircularProgressIndicator(),);
              } else if (state is GetCategoriesSuccess) {
                return Container(
                  margin: EdgeInsets.only(top: 24),
                  height: 156,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: List.generate(
                      state.specialists.length, 
                      (index) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: _categoryBg
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(_getCategoryIcon(state.specialists[index].name), color: _mainTextColor,),
                            Text(state.specialists[index].name)
                          ],
                        ),
                      )),
                  ),
                );
              } else {
                return Text('error');
              }
            },
          )
        ],
      ),
    );
  }

  String _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Heart': return AppIcons.heart;
      case 'Dental': return AppIcons.dental;
      case 'Kidney': return AppIcons.kidney;
      case 'Stomach': return AppIcons.stomach;
      case 'Lung': return AppIcons.lung;
      case 'Brain': return AppIcons.brain;
      case 'Mental': return AppIcons.mental;
      case 'Liver': return AppIcons.liver;
      default: return AppIcons.heart;
    }
  }

  Padding _buidTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is GetUserLoading) {
                return const CircularProgressIndicator(strokeWidth: 2,);
              } else if (state is GetUserSuccess) {
                UserModel user = state.user;
                String photoURL = user.photoURL??AppImages.defaultAvatar;
            
                return Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _navBarColor,
                          width: 1
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: NetworkImage(photoURL))
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.welcome, style: AppTextStyles.body2Regular!.copyWith(color: _welcomeTextColor)),
                          Text(user.name??AppStrings.noName, style: AppTextStyles.bodyMedium!.copyWith(color: _mainTextColor))
                        ],
                      ),
                    )
                  ],
                );
              } else if (state is GetUserFailure) {
                return Text(state.message);
              } else return SizedBox();
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) => SearchView(),
                  // transitionsBuilder: (_, anim, __, child) {
                  //   return FadeTransition(opacity: anim, child: child);
                  // },
                ),
              );
            },
            child: Image.asset(
              AppIcons.search,
              color: _mainTextColor,),
          )
        ],
      ),
    );
  }
}
