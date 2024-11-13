import 'package:doctor_appointment/core/resources/colors.dart';
import 'package:doctor_appointment/core/resources/icons.dart';
import 'package:doctor_appointment/core/resources/images.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/resources/text_styles.dart';
import 'package:doctor_appointment/data/models/chat_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/presentation/blocs/chat_cubit.dart';
import 'package:doctor_appointment/presentation/notifiers/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ChatConversationView extends StatefulWidget {
  final DoctorModel doctor;

  const ChatConversationView({
    super.key, 
    required this.doctor
  });

  @override
  State<ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<ChatConversationView> {
  late final Color _mainTextColor;
  late final Color _cardBgColor;
  late final Color _secondaryTextColor;
  late final TextEditingController _chatController;

  @override
  void initState() {
    super.initState();

    ThemeMode themeMode = Provider.of<ThemeNotifier>(context, listen: false).currentThemeMode;
    if (themeMode == ThemeMode.light) {
      _mainTextColor = AppColors.blackColor;
      _cardBgColor = AppColors.gray4;
      _secondaryTextColor = AppColors.gray1;
    } else {
      _mainTextColor = AppColors.darkWhite;
      _cardBgColor = AppColors.darkFg;
      _secondaryTextColor = AppColors.gray2;
    }

    _chatController = TextEditingController();
    Provider.of<ChatCubit>(context, listen: false).startListeningToChat(widget.doctor.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopbar(context),
          Expanded(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (_, state) {
                if (state is ChatUpdated) {
                  List<ChatMessage>? conversation = state.chat.conversation;
                  String uid = state.chat.uid;
                  String doctor_id = state.chat.doctor_id;
                  
                  if (conversation == null) return SizedBox();

                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 2,),
                    itemCount: conversation.length,
                    itemBuilder: (_, index) {
                      if (conversation[index].sender_id == uid) {
                        return Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(conversation[index].message, style: AppTextStyles.body2Regular!.copyWith(color: _mainTextColor),),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _cardBgColor,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text(conversation[index].message, style: AppTextStyles.body2Regular!.copyWith(color: _mainTextColor),),
                          ),
                        );
                      }
                    }
                  );

                } else return Center(child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2,) ,);
              }),
          )),
          _buildInputMessage(context)
        ],
      )),
    );
  }

  Container _buildInputMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: _chatController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                hintText: AppStrings.typeHint,
                hintStyle: AppTextStyles.body2Medium!.copyWith(color: _secondaryTextColor),
                filled: true,
                fillColor: _cardBgColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(16)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(16)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(16)
                )
              ),
            ),
          ),
          SizedBox(width: 4,),
          GestureDetector(
            onTap: () {
              if (_chatController.text.isEmpty) return;

              Provider.of<ChatCubit>(context, listen: false).sendMessage(_chatController.text);
              _chatController.text = '';
            },
            child: Container(
              width: 24,
              height: 24,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(AppIcons.send)),
              ),
            ),
          )
        ],
      ) ,
    );
  }

  Padding _buildTopbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 34),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(AppIcons.back, color: _mainTextColor,)),
          SizedBox(width: 24,),
          ClipOval(child: Image.network(
            widget.doctor.photoURL??AppImages.defaultAvatar,
            width: 32,
            height: 32,
          ),),
          SizedBox(width: 8,),
          Text(widget.doctor.name, style: AppTextStyles.bodyBold,),
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(AppIcons.voiceCall, color: _mainTextColor,),
              SizedBox(width: 16,),
              Image.asset(AppIcons.videoCall, color: _mainTextColor,),
              SizedBox(width: 16,),
              Image.asset(AppIcons.kebab, color: _mainTextColor,),
            ],
          ))
        ],
      ),
      
    );
  }
}