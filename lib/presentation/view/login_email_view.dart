import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/validator.dart';
import 'package:doctor_appointment/presentation/blocs/user_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:doctor_appointment/presentation/widgets/input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginEmailView extends StatefulWidget {
  const LoginEmailView({super.key});

  @override
  State<LoginEmailView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginEmailView> {
  late Color _fillColor;
  late Color _borderColor;
  late Color _borderFocusColor;
  late Color _borderErrorColor;
  late Color _textColor;
  late Color _hintColor; 
  late TextEditingController _textEditingController;
  late InputFieldController _inputFieldController;
  late final UserCubit _userCubit;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
    _inputFieldController = InputFieldController();
    _userCubit = Provider.of<UserCubit>(context, listen: false);
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
  }

  @override
  void dispose() {
    super.dispose();
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 40, bottom: 80),
                  child: Text(
                    AppStrings.signIn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.emailInput, style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      child: InputField(
                        textController: _textEditingController,
                        inputController: _inputFieldController,
                        fillColor: _fillColor,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.emailHint,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Center(child: _buildNextButton()),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 32, bottom: 46),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                        children: [
                          TextSpan(text: AppStrings.recomendSignUp, style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                            text: ' ${AppStrings.createAccount}', 
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushNamed(context, RouteName.CHECK_MAIL_SIGNUP_PAGE);
                            })
                        ]
                      )),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.bg1,
                            height: 1,
                            thickness: 1,
                        )),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(AppStrings.or)),
                        Expanded(
                          child: Divider(
                            color: AppColors.bg1,
                            height: 1,
                            thickness: 1,
                        )),
                      ],
                    ),
                    _buildLoginMethod(context)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer<UserCubit, UserState> _buildNextButton() {
    String email = _textEditingController.text;

    return BlocConsumer<UserCubit, UserState>(
      listener: (BuildContext context, UserState state) { 
        final bool isTop = ModalRoute.of(context)?.isCurrent??false;
        if (!isTop) return;
        
        if (state is CheckEmailSuccess) {
          if (state.result == false) {
            _inputFieldController.setInputState(InputState.error, errorText: AppStrings.userNotFound);
          } else {
            Navigator.pushNamed(context, RouteName.LOGIN_PAGE, arguments: {'email': email});
          }
        }
      },
      builder:(context, state) {
        return BigPrimaryButton(
          onPress: () {
            email = _textEditingController.text;
            String? message = Validator.validateEmail(email);
            if (message == null) {
              _userCubit.checkEmail(email);
            } else {
              _inputFieldController.setInputState(InputState.error, errorText: message);
            }                        
          },
          child: state is CheckEmailLoading
          ? CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,) 
          : const Text(AppStrings.continueAction),
        );
      },
    );
  }

  Container _buildLoginMethod(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //login with google
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg1
              ),
              child: Image.asset(AppIcons.google),
            ),
          ),
          GestureDetector(
            onTap: () {
              //login with apple
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg1
              ),
              child: Image.asset(AppIcons.apple),
            ),
          ),
          GestureDetector(
            onTap: () {
              //login with facebook
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg1
              ),
              child: Image.asset(AppIcons.facebook),
            ),
          )
        ],
      ),
    );
  }
}