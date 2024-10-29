import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/app_shared_prefs.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/user_remote_datasource.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentPage = 0;
  final PageController _pageController = PageController();
  final ValueNotifier<double> _slideNotifier = ValueNotifier(0);
  late final UserRepository userRepository;

  @override
  void initState() {
    super.initState();
    userRepository = locator.get<UserRepository>();

    _pageController.addListener(() {
      double newValue = double.parse(_pageController.page?.toStringAsFixed(1)??'0');
      if (newValue != _slideNotifier.value)
        _slideNotifier.value = newValue;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    int numPage = AppImages.onboardings.length;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [PageView.builder(
            controller: _pageController,
            itemCount: numPage,
            onPageChanged: (value) {
              currentPage = value;
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.asset(
                  AppImages.onboardings[index],
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36)
                        )
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 32),
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(AppStrings.onboardings[index][0],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 32, bottom: 32),
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(AppStrings.onboardings[index][1],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,),
                          ),
                          
                        ],
                      ),
                    ),
                  ),

                ]
              );
            }),
            Positioned(
              bottom: 12,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: _slideNotifier,
                    builder: (BuildContext context, value, Widget? child) { 
                      return DotIndicator(numPage: numPage, currentSlider: value);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    child: BigPrimaryButton(
                      child: const Text(AppStrings.nextAction),
                      onPress: () async {
                        if (currentPage == numPage - 1) {
                          //check login
                          await AppSharedPref.setFirstLaunch(false);
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            FirebaseAuth.instance.currentUser == null ? RouteName.CHECK_MAIL_LOGIN_PAGE : RouteName.HOME_PAGE, 
                            (Route<dynamic> route) => false);
                        } else {
                          _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
                        }
                      },
                      )),
                ],
              ),
            )
          ]
        ),
      )
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.numPage,
    required this.currentSlider,
  });

  final int numPage;
  final double currentSlider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(numPage, (i) => 
      Container(
        width: i == currentSlider.round() ? 25 : 4,
        height: 4,
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4),
          color: Theme.of(context).primaryColor
        ),
      )),
      );
  }
}