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

class SignupEmailView extends StatefulWidget {
  const SignupEmailView({super.key});

  @override
  State<SignupEmailView> createState() => _SignupEmailViewState();
}

class _SignupEmailViewState extends State<SignupEmailView> {
  late Color _fillColor;
  late Color _borderColor;
  late Color _borderFocusColor;
  late Color _borderErrorColor;
  late Color _textColor;
  late Color _hintColor; 
  late TextEditingController _fullNameController;
  late InputFieldController _inputFullNameController;
  late final TextEditingController _emailController;
  late final InputFieldController _inputEmailController;
  late final UserCubit _userCubit;

  @override
  void initState() {
    super.initState();

    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _inputFullNameController = InputFieldController();
    _inputEmailController = InputFieldController();
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
                      Navigator.pushNamedAndRemoveUntil(context, RouteName.CHECK_MAIL_LOGIN_PAGE, (_) => false);
                    },
                    child: Image.asset(AppIcons.back, color: Theme.of(context).colorScheme.onPrimary,),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 56),
                  child: Text(
                    AppStrings.signUp,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.fullNameInput, 
                      style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      child: InputField(
                        fillColor: _fillColor,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.fullNameHint,
                        textController: _fullNameController,
                        inputController: _inputFullNameController,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Text(
                      AppStrings.emailInput, 
                      style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 36),
                      child: InputField(
                        fillColor: _fillColor,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.emailHint,
                        textController: _emailController,
                        inputController: _inputEmailController,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Center(child: _buildNextButton(context)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 32, bottom: 46),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                        children: [
                          TextSpan(text: AppStrings.recomendLogin, style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                            text: ' ${AppStrings.signIn}', 
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushNamedAndRemoveUntil(context, RouteName.CHECK_MAIL_LOGIN_PAGE, (_) => false);
                            }
                          )
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

  BlocConsumer<UserCubit, UserState> _buildNextButton(BuildContext context) {
    String email = _emailController.text;
    String fullName = _fullNameController.text;
    String? messageEmail;
    String? messageFullName;

    return BlocConsumer<UserCubit, UserState>(
      listener: (BuildContext context, UserState state) { 
        if (state is CheckEmailSuccess) {
          messageEmail = state.result == true ? AppStrings.emailInUse : null;

          if (messageFullName != null)
            _inputFullNameController.setInputState(InputState.error, errorText: messageFullName);
          if (messageEmail != null) 
            _inputEmailController.setInputState(InputState.error, errorText: messageEmail);
          if (messageFullName == null && messageEmail == null) {
            Navigator.pushNamed(context, RouteName.SIGNUP_PAGE, arguments: {
              'fullName': fullName,
              'email': email
            });
          }
        }
      },
      builder:(context, state) {
        return BigPrimaryButton(
          onPress: () {
            fullName = _fullNameController.text;
            email = _emailController.text;

            messageEmail = Validator.validateEmail(email);
            messageFullName = Validator.validateFullName(fullName);

            if (messageEmail == null) {
              _userCubit.checkEmail(email);
            } else {
              _inputEmailController.setInputState(InputState.error, errorText: messageEmail);
              if (messageFullName != null) {
                _inputFullNameController.setInputState(InputState.error, errorText: messageFullName);
              }
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