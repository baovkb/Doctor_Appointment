import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/validator.dart';
import 'package:doctor_appointment/presentation/blocs/auth_bloc.dart';
import 'package:doctor_appointment/presentation/blocs/user_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:doctor_appointment/presentation/widgets/input_field.dart';
import 'package:doctor_appointment/presentation/widgets/success_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  final String email;
  const ForgotPasswordView({super.key, required this.email});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late Color _fillColor;
  late Color _borderColor;
  late Color _borderFocusColor;
  late Color _borderErrorColor;
  late Color _textColor;
  late Color _hintColor; 
  late final TextEditingController _emailController;
  late final InputFieldController _inputEmailController;
  late final AuthBloc _authBloc;
  late final UserCubit _userCubit;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _inputEmailController = InputFieldController();
    _userCubit = Provider.of<UserCubit>(context, listen: false);
    _authBloc = Provider.of<AuthBloc>(context, listen: false);

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _fillColor = AppColors.bg1;
      _borderColor = AppColors.bg1;
      _borderFocusColor = AppColors.primaryColor;
      _borderErrorColor = AppColors.redColor;
      _textColor = AppColors.blackColor;
      _hintColor = AppColors.gray2;
    } else {
      _fillColor = AppColors.darkFg;
      _borderColor = AppColors.darkFg;
      _borderFocusColor = AppColors.primaryColor;
      _borderErrorColor = AppColors.darkRed;
      _textColor = AppColors.darkWhite;
      _hintColor = AppColors.gray1;
    }

    _emailController.text = widget.email;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(AppIcons.back, color: Theme.of(context).colorScheme.onPrimary,),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 80),
                  child: Text(
                    AppStrings.resetPassword,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.emailInput, style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      child: InputField(
                        textController: _emailController,
                        inputController: _inputEmailController,
                        fillColor: _fillColor,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.emailHint,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Center(child: _buildResetPasswordButton()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocListener<AuthBloc, AuthState> _buildResetPasswordButton() {
    String email = _emailController.text;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthResetPasswordSuccess) {
          if (authState.success == true) {
            showDialog(
              context: context, 
              barrierDismissible: false,

              builder: (_) => SuccessDialog(
                message: AppStrings.successSendEmailResetPassMsg,
                onButtonTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, RouteName.CHECK_MAIL_LOGIN_PAGE, (_) => false);
                },
                textButton: AppStrings.continueAction));
          } else {
            //notify send email reset pass fail
          }
        } else if (authState is AuthFailure) {
          //notify send email reset pass fail
        }
      },
      child: BlocConsumer<UserCubit, UserState>(
        listener: (BuildContext context, UserState state) {         
          if (state is CheckEmailSuccess) {
            if (state.result == false) {
              _inputEmailController.setInputState(InputState.error, errorText: AppStrings.userNotFound);
            } else {
              // send reset email
              _authBloc.add(AuthResetPasswordRequested(email));
            }
          }
        },
        builder:(context, state) {
          return BigPrimaryButton(
            onPress: () {
              email = _emailController.text;
              String? message = Validator.validateEmail(email);
              if (message == null) {
                _userCubit.checkEmail(email);
              } else {
                _inputEmailController.setInputState(InputState.error, errorText: message);
              }                        
            },
            child: state is CheckEmailLoading
            ? CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,) 
            : const Text(AppStrings.continueAction),
          );
        },
      ),
    );
  }
}