import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum InputState {
  active,
  inactive,
  error
}

class InputField extends StatefulWidget {
  final String? hintText;
  final bool isObscured;
  final TextEditingController? textController;
  final InputFieldController? inputController;
  final Color suffixIconColor;
  final Color fillColor;
  final Color borderColor;
  final Color borderFocusColor;
  final Color borderErrorColor;
  final Color textColor;
  final Color hintColor;
  final bool autofocus;

  const InputField({
    super.key,
    this.textController,
    this.hintText,
    this.inputController,
    this.isObscured = false,
    this.fillColor = Colors.white,
    this.borderColor = Colors.black38,
    this.borderFocusColor = Colors.blue,
    this.borderErrorColor = Colors.redAccent,
    this.suffixIconColor = const Color(0xffB2BCC9),
    this.textColor = Colors.black,
    this.hintColor = Colors.black38,
    this.autofocus = false
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  late InputFieldController _inputFieldController;
  late bool _isObscured;
  late Color _suffixIconColor;
  late Color _fillColor;
  late Color _borderColor;
  late Color _borderFocusColor;
  late Color _borderErrorColor;
  late Color _textColor;
  late Color _hintColor;
  late bool _autofocus;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isObscured;
    _focusNode = FocusNode();
    _suffixIconColor = widget.suffixIconColor;
    _fillColor = widget.fillColor;
    _borderColor = widget.borderColor;
    _borderFocusColor = widget.borderFocusColor;
    _borderErrorColor = widget.borderErrorColor;
    _inputFieldController = widget.inputController ?? InputFieldController();
    _textColor = widget.textColor;
    _hintColor = widget.hintColor;
    _autofocus = widget.autofocus;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InputFieldController>(
      create: (_) => _inputFieldController,
      child: Consumer<InputFieldController>(
        builder: (context, value, child) {
          InputState state = value.currentState;
          bool isObscured = value.isObscured;
          String? errorText = value.errorText;

          return TextField(
            autofocus: _autofocus,
            style: TextStyle(
              color: state == InputState.error ? AppColors.redColor : _textColor,
              fontFamily: AppFonts.primaryFont,
              fontSize: 16,
            ),
            focusNode: _focusNode,
            onChanged: (value) {
              if (state == InputState.error) {
                _inputFieldController.setInputState(InputState.active);
              }
            },
            controller: widget.textController,
            obscureText: (_isObscured & isObscured),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontFamily: AppFonts.primaryFont,
                fontSize: 16,
                color: _hintColor
              ),
              filled: true,
              fillColor: _fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 0, color: AppColors.gray4)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 0, color: _borderColor)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(width: 0, color: _borderFocusColor)
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 0, color: _borderErrorColor)
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(width: 0, color: _borderErrorColor)
              ),
              suffixIcon: _isObscured 
                ? IconButton(
                  onPressed: () => _inputFieldController.setObscuredMode(!isObscured), 
                  icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: _suffixIconColor,))
                : null,
              errorText: state == InputState.error ? errorText : null,
              errorStyle: TextStyle(
                color: AppColors.redColor,
                fontFamily: AppFonts.primaryFont,
                fontSize: 14,
              )
            ),
          );
        },
      ),
    );
  }
}

class InputFieldController extends ChangeNotifier {
  InputState currentState;
  String? errorText;
  bool isObscured;

  InputFieldController({this.currentState = InputState.inactive}): isObscured = true;

  void setInputState(InputState state, {String? errorText}) {
    currentState = state;
    this.errorText = errorText;
    notifyListeners();
  }

  void setObscuredMode(bool mode) {
    isObscured = mode;
    notifyListeners();
  }
}