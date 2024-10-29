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
import 'package:doctor_appointment/presentation/widgets/small_primary_button.dart';
import 'package:doctor_appointment/presentation/widgets/success_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  final String fullName;
  final String email;

  const SignupView({super.key, required this.fullName, required this.email});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late Color _fillColor;
  late Color _borderColor;
  late Color _borderFocusColor;
  late Color _borderErrorColor;
  late Color _textColor;
  late Color _hintColor; 
  late TextEditingController _passwordController;
  late InputFieldController _inputPasswordController;
  late final TextEditingController _confirmPasswordController;
  late final InputFieldController _inputConfirmPasswordController;
  late final AuthBloc _authBloc;
  late final UserCubit _userCubit;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _inputPasswordController = InputFieldController();
    _inputConfirmPasswordController = InputFieldController();
    _authBloc = Provider.of<AuthBloc>(context, listen: false);
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
                      Navigator.pop(context);
                    },
                    child: Image.asset(AppIcons.back, color: Theme.of(context).colorScheme.onPrimary,),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 56),
                  child: Text(
                    AppStrings.setPassword,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.newPassword, 
                      style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      child: InputField(
                        fillColor: _fillColor,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.newPassword,
                        isObscured: true,
                        textController: _passwordController,
                        inputController: _inputPasswordController,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Text(
                      AppStrings.confirmPassword, 
                      style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 36),
                      child: InputField(
                        fillColor: _fillColor,
                        isObscured: true,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.confirmPassword,
                        textController: _confirmPasswordController,
                        inputController: _inputConfirmPasswordController,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Center(child: _buildSignUpButton(context)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 32, bottom: 46),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                        children: [
                          TextSpan(text: AppStrings.recomendLogin, style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                            text: ' ${AppStrings.signUp}', 
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.popUntil(
                                context, 
                                (predicate) => predicate.settings.name == RouteName.CHECK_MAIL_LOGIN_PAGE);
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

  BlocConsumer<AuthBloc, AuthState> _buildSignUpButton(BuildContext context) {
    String password;
    String confirmPassword;
    bool signUpSuccess = false;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) async { 
        if (state is AuthSuccess) {
          //sign up successful
          signUpSuccess = true;

          _authBloc.add(AuthSignOutRequested());
        } else if (state is AuthFailure) {
          debugPrint(state.message);
        } else if (state is UnAuth) {
          if (signUpSuccess) {
            showDialog(
              barrierDismissible: false,
              context: context, 
              builder: (_) {
                return SuccessDialog(
                  message: AppStrings.successSignUpMsg, 
                  textButton: AppStrings.continueAction,
                  onButtonTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteName.CHECK_MAIL_LOGIN_PAGE, (_) => false);
                  },
                );
              }
            );
          }
        }
      },
      builder:(context, state) {
        return BigPrimaryButton(
          onPress: () {
            password = _passwordController.text;
            confirmPassword = _confirmPasswordController.text;

            if (confirmPassword != password) {
              _inputConfirmPasswordController.setInputState(InputState.error, errorText: AppStrings.passwordNotMatch);
            } else {
              String? message = Validator.validatePassword(password, minLength: 6);
              if (message != null) {
                _inputPasswordController.setInputState(InputState.error, errorText: message);
              } else {
                _authBloc.add(AuthSignUpRequested(email: widget.email, password: password, name: widget.fullName));
              }
            }
            
          },
          child: state is AuthLoading
          ? CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,) 
          : const Text(AppStrings.signUp),
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