import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/core/utils/time_converter.dart';
import 'package:doctor_appointment/data/models/chat_model.dart';
import 'package:doctor_appointment/data/models/doctor_model.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:doctor_appointment/data/repositories/chat_repository.dart';
import 'package:doctor_appointment/data/repositories/doctor_repository.dart';
import 'package:doctor_appointment/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  late final ChatRepository _chatRepository;
  late final UserRepository _userRepository;
  late final DoctorRepository _doctorRepository;
  StreamSubscription? _chatSubscription;
  String? _uid;
  String? _chatID;
  
  ChatCubit(): super(ChatInitial()) {
    _chatRepository = locator.get<ChatRepository>();
    _userRepository = locator.get<UserRepository>();
    _doctorRepository = locator.get<DoctorRepository>();
  }

  sendMessage(String message) async {
    if (_uid == null || _chatID == null) {
      return;
    }

    ChatMessage chatMessage = ChatMessage(sender_id: _uid!, message: message, time: TimeConverter.getUnixTime());
    _chatRepository.sendMessage(_chatID!, chatMessage);
  }

  startListeningToChat(String doctor_id) async {
    emit(ChatLoading());

    final userfuture = _userRepository.getCurrentUser(forceUpdate: true);
    final docFuture = _doctorRepository.getDoctorByID(doctor_id);

    final results = await Future.wait([userfuture, docFuture]);
    final leftResult = results.where((e) => e.isLeft());
    if (leftResult.isNotEmpty) {
      final errors = leftResult.map((e) => e.fold((failure) => failure.message, (_) => ''));
      emit(ChatFailure(errors));
      return;
    }

    UserModel user = results[0].fold(
      (failure) => null, 
      (user) => user as UserModel)!;
    DoctorModel doc = results[1].fold(
      (failure) => null, 
      (doc) => doc as DoctorModel)!;

    final foundChatID = user.chat_id?.firstWhere(
      (condUser) => doc.chat_id?.any((condDoc) => condDoc == condUser) ?? false,
      orElse: () => '',
    );

    ChatModel? gotChat = null; 
    if (foundChatID != null && foundChatID.isNotEmpty) {
      //get chat
      final chatEither = await _chatRepository.getChatByID(foundChatID);
      final chatResult = chatEither.fold(
        (failure) => failure.message, 
        (chat) => chat);

      if (chatEither.isLeft()) {
        emit(ChatFailure(chatResult));
        return;
      } else {
        gotChat = chatResult as ChatModel;
      }
      
    } else {
      //create chat
      final chatEither = await _chatRepository.addChat(uid: user.uid, doctor_id: doc.id);
      final chatResult = chatEither.fold(
        (failure) => failure.message, 
        (chat) => chat);
      
      if (chatEither.isLeft()) {
        emit(ChatFailure(chatResult));
        return;
      } else {
        gotChat = chatResult as ChatModel;
      }

      //update user, doctor
      if (user.chat_id == null) user.chat_id = [gotChat.id];
      else user.chat_id!.add(gotChat.id);
      if (doc.chat_id == null) doc.chat_id = [gotChat.id];
      else doc.chat_id!.add(gotChat.id);

      final userUpdateFuture =  _userRepository.updateUser(user);
      final docUpdateFuture = _doctorRepository.updateDoctor(id: doc.id, chat_id: doc.chat_id);

      final updateResults = await Future.wait([userUpdateFuture, docUpdateFuture]);
    }

    _uid = user.uid;
    _chatID = gotChat.id;

    emit(ChatUpdated(gotChat));

    _chatSubscription?.cancel();
    _chatSubscription = _chatRepository.getChatStream(gotChat.id).listen((chat) {
      emit(ChatUpdated(chat));
    });
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatUpdated extends ChatState {
  final ChatModel chat;
  ChatUpdated(this.chat);

  @override
  List<Object?> get props => [chat];
}
class ChatFailure extends ChatState {
  final dynamic message;

  ChatFailure(this.message);

  @override
  List<Object?> get props => [message];
}
class SendMessageFailure extends ChatState {
  final dynamic message;
  SendMessageFailure(this.message);

  @override
  List<Object?> get props => [message];
}