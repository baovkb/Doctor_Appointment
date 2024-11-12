import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/presentation/view/appointment_detail_view.dart';
import 'package:doctor_appointment/presentation/view/bookings_view.dart';
import 'package:doctor_appointment/presentation/view/change_password_view.dart';
import 'package:doctor_appointment/presentation/view/chat_conversation_view.dart';
import 'package:doctor_appointment/presentation/view/chat_view.dart';
import 'package:doctor_appointment/presentation/view/doctor_infor_view.dart';
import 'package:doctor_appointment/presentation/view/forgot_password_view.dart';
import 'package:doctor_appointment/presentation/view/home_view.dart';
import 'package:doctor_appointment/presentation/view/login_email_view.dart';
import 'package:doctor_appointment/presentation/view/login_view.dart';
import 'package:doctor_appointment/presentation/view/onboarding_view.dart';
import 'package:doctor_appointment/presentation/view/profile_view.dart';
import 'package:doctor_appointment/presentation/view/review_view.dart';
import 'package:doctor_appointment/presentation/view/signup_email_view.dart';
import 'package:doctor_appointment/presentation/view/signup_view.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case RouteName.HOME_PAGE:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
          settings: RouteSettings(name: RouteName.HOME_PAGE)
        );
      case RouteName.ONBOARDING_PAGE: 
        return MaterialPageRoute(
          builder: (_) => const OnboardingView(),
          settings: RouteSettings(name: RouteName.ONBOARDING_PAGE)
        );
      case RouteName.CHECK_MAIL_LOGIN_PAGE:
        return MaterialPageRoute(
          builder: (_) => const LoginEmailView(),
          settings: RouteSettings(name: RouteName.CHECK_MAIL_LOGIN_PAGE)
        );
      case RouteName.LOGIN_PAGE:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => LoginView(email: args['email']??''),
          settings: RouteSettings(name: RouteName.LOGIN_PAGE)
        );
      case RouteName.CHECK_MAIL_SIGNUP_PAGE:
        return MaterialPageRoute(
          builder: (_) => const SignupEmailView(),
          settings: RouteSettings(name: RouteName.CHECK_MAIL_SIGNUP_PAGE)
        );
      case RouteName.SIGNUP_PAGE:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => SignupView(fullName: args['fullName']??'', email: args['email']??''),
          settings: RouteSettings(name: RouteName.SIGNUP_PAGE)
        );
      case RouteName.FORGOT_PASSWORD_PAGE:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordView(email: args['email']??'',),
          settings: const RouteSettings(name: RouteName.FORGOT_PASSWORD_PAGE));
      case RouteName.CHANGE_PASSWORD_PAGE:
        return MaterialPageRoute(
          builder: (_) => ChangePasswordView(),
          settings: RouteSettings(name: RouteName.CHANGE_PASSWORD_PAGE));
      case RouteName.BOOKINGS_PAGE:
        return MaterialPageRoute(
          builder: (_) => BookingsView(),
          settings: RouteSettings(name: RouteName.BOOKINGS_PAGE)
        );
      case RouteName.CHAT_PAGE:
        return MaterialPageRoute(
          builder: (_) => ChatView(),
          settings: RouteSettings(name: RouteName.CHAT_PAGE)
        );
      case RouteName.PROFILE_PAGE:
        return MaterialPageRoute(
          builder: (_) => ProfileView(),
          settings: RouteSettings(name: RouteName.PROFILE_PAGE)
        );
      case RouteName.DOCTOR_INFO_PAGE:
      final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => DoctorInforView(
            doctorModel: args['doctor'], 
            specialistModel: args['specialist'],
            locationModel: args['location'],
            scheduleModel: args['schedule'],),
          settings: RouteSettings(name: RouteName.DOCTOR_INFO_PAGE));
      case RouteName.APPOINTMENT_DETAIL:
      final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => AppointmentDetailView(
            doctorModel: args['doctor'], 
            specialistModel: args['specialist'],
            locationModel: args['location'],
            scheduleModel: args['schedule'],
            appointmentModel: args['appointment'],
            viewMode: args['viewMode']??true,
          ),
          settings: RouteSettings(name: RouteName.APPOINTMENT_DETAIL)
        );
      case RouteName.REVIEW:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReviewView(
            doctorModel: args['doctor'], 
            specialistModel: args['specialist'], 
            locationModel: args['location'], 
            scheduleModel: args['schedule'], 
            appointmentModel: args['appointment'],
            review: args['review'],),
          settings: RouteSettings(name: RouteName.REVIEW));
      case RouteName.CONVERSATION:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ChatConversationView(doctor: args['doctor']),
          settings: RouteSettings(name: RouteName.CONVERSATION));
      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingView(),
          settings: RouteSettings(name: settings.name)
        );
    }
  }
}