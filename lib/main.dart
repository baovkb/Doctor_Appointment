import 'package:doctor_appointment/core/utils/app_shared_prefs.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:doctor_appointment/presentation/blocs/add_appointment_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/add_review_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/auth_bloc.dart';
import 'package:doctor_appointment/presentation/blocs/category_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/available_schedule_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/chat_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/get_doctors_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/schedule_search_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/schedules_by_ids_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/upcoming_appointment_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/user_apppointment_cubit.dart';
import 'package:doctor_appointment/presentation/blocs/user_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/route_generator.dart';
import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //config firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //config hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Box<UserModel> userBox = await Hive.openBox<UserModel>('UserBox');

  //config get_id
  await configDependencies(userBox);

  //set statusbar's color to transparent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeNotifier themeNotifier;

  @override
  void initState() {
    super.initState();
    themeNotifier = ThemeNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => themeNotifier),
        BlocProvider<UserCubit>(create: (_) => UserCubit()),
        BlocProvider<CategoryCubit>(create: (_) => CategoryCubit()),
        BlocProvider<AvailableScheduleCubit>(create: (_) => AvailableScheduleCubit()),
        BlocProvider<ScheduleSearchCubit>(create: (_) => ScheduleSearchCubit()),
        BlocProvider<SchedulesByIDsCubit>(create: (_) => SchedulesByIDsCubit()),
        BlocProvider<AddAppointmentCubit>(create: (_) => AddAppointmentCubit()),
        BlocProvider<UserAppointmentCubit>(create: (_) => UserAppointmentCubit()),
        BlocProvider<UpComingAppointmentCubit>(create: (_) => UpComingAppointmentCubit()),
        BlocProvider<AddReviewCubit>(create: (_) => AddReviewCubit()),
        BlocProvider<GetDoctorsCubit>(create: (_) => GetDoctorsCubit()),
        BlocProvider<ChatCubit>(create: (_) => ChatCubit())
      ],
      child: Consumer<ThemeNotifier>(
        builder: (BuildContext context, ThemeNotifier value, Widget? child) { 
          return FutureBuilder(
            future: AppSharedPref.checkFirstLaunch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active
              || snapshot.connectionState == ConnectionState.done) {
                Provider.of<UserCubit>(context, listen: false).getCurrentUser(forceUpdate: true);
          
                if (snapshot.hasData) {
                  bool? isFirstLaunch = snapshot.data;
                  return _MyAppWidget(
                    (isFirstLaunch == null || isFirstLaunch == true) 
                    ? RouteName.ONBOARDING_PAGE
                    : null,
                    themeNotifier,
                    value.currentThemeMode);
                } else if (snapshot.hasError) {
                  debugPrint('snapshot error');
                  return SizedBox();
                } else {
                  return SizedBox();
                }
              } else return SizedBox();
            },
          );
        },
      ),
    );
  }

  
  Widget _MyAppWidget(String? initialRoute, ThemeNotifier themeNotifier, ThemeMode themeMode) {
    if (initialRoute == null) {
      return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is GetUserSuccess) {
            initialRoute = RouteName.HOME_PAGE;
            FlutterNativeSplash.remove();
          } else if (state is GetUserFailure) {
            initialRoute = RouteName.CHECK_MAIL_LOGIN_PAGE;
            FlutterNativeSplash.remove();
          } else if (state is GetUserLoading) {
            return SizedBox();
          }
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.lightTheme,
            darkTheme: themeNotifier.darkTheme,
            themeMode: themeMode,
            initialRoute: initialRoute,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        } 
        ,);
    } else {
      FlutterNativeSplash.remove();

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeNotifier.lightTheme,
        darkTheme: themeNotifier.darkTheme,
        themeMode: themeMode,
        initialRoute: initialRoute,
        onGenerateRoute: RouteGenerator.generateRoute,
      ); 
    }
  }
}
