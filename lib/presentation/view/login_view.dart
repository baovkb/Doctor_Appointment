import 'package:doctor_appointment/core/constants/route_name.dart';
import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/validator.dart';
import 'package:doctor_appointment/presentation/blocs/auth_bloc.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:doctor_appointment/presentation/widgets/big_primary_button.dart';
import 'package:doctor_appointment/presentation/widgets/input_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  final String email;

  const LoginView({super.key, required this.email});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late Color _fillColor;
  late Color _borderColor;
  late Color _borderFocusColor;
  late Color _borderErrorColor;
  late Color _textColor;
  late Color _hintColor;
  late TextEditingController _passwordController;
  late InputFieldController _inputPasswordController;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _inputPasswordController = InputFieldController();
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
                    AppStrings.signIn,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.passwordInput, 
                      style: Theme.of(context).textTheme.bodyLarge,),
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 24),
                      child: InputField(
                        textController: _passwordController,
                        inputController: _inputPasswordController,
                        fillColor: _fillColor,
                        borderColor: _borderColor,
                        borderFocusColor: _borderFocusColor,
                        borderErrorColor: _borderErrorColor,
                        hintText: AppStrings.passwordHint,
                        isObscured: true,
                        autofocus: true,
                        hintColor: _hintColor,
                        textColor: _textColor,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 36),
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context, 
                          RouteName.FORGOT_PASSWORD_PAGE,
                          arguments: {'email': widget.email}),
                        child: const Text(
                          AppStrings.forgotPassword, 
                          textAlign: TextAlign.end,),
                      )),
                    Center(child: _buildLoginButton(context)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 32, bottom: 46),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                        children: [
                          TextSpan(text: AppStrings.recomendSignUp, style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.pushNamedAndRemoveUntil(context, RouteName.CHECK_MAIL_SIGNUP_PAGE, (predicate) => false);
                            },
                            text: ' ${AppStrings.createAccount}', 
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
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

  BlocConsumer _buildLoginButton(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        return BigPrimaryButton(
          child: state is AuthLoading
          ? CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,) 
          : const Text(AppStrings.signIn),
          onPress:() {
            String password = _passwordController.text;
            String? message = Validator.validatePassword(password, minLength: 6);

            if (message == null) {
              _authBloc.add(AuthSignInRequested(email: widget.email, password: password));
            } else {
              _inputPasswordController.setInputState(InputState.error, errorText: message);
            }
            
          },);
      }, 
      listener: (context, state) {
        var isTop = ModalRoute.of(context)?.isCurrent??false;
        if (!isTop) return;

        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, RouteName.HOME_PAGE, (predicate) => false);
        } else if (state is AuthFailure) {
          _inputPasswordController.setInputState(InputState.error, errorText: state.message);
        }
      });
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
            onTap: () {},
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