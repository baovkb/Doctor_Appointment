import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/chat_remote_datasource.dart';
import 'package:doctor_appointment/data/models/chat_model.dart';

class ChatRepository {
  late final ChatRemoteDatasource _chatRemoteDatasource;
  
  ChatRepository() {
    _chatRemoteDatasource = locator.get<ChatRemoteDatasource>();
  }

  Future<Either<Failure, ChatModel>> getChatByID(String id) async {
    try {
      final result = await _chatRemoteDatasource.getChatByID(id);
      return result == null ? Left(DataNotFoundFailure(AppStrings.dataNotFound)): Right(result);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, ChatModel>> addChat({required String uid, required String doctor_id}) async {
    try {
      final chat = await _chatRemoteDatasource.addChat(uid: uid, doctor_id: doctor_id);
      return Right(chat);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> sendMessage(String chat_id, ChatMessage chatMessage) async {
    try {
      await _chatRemoteDatasource.sendMessage(chat_id, chatMessage);
      return Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Stream<ChatModel> getChatStream(String id) {
    return _chatRemoteDatasource.getChatStream(id).map(
      (chat) {
        if (chat.conversation != null) {
          final sortedConversation = chat.conversation!.entries.toList()..sort((a, b) => int.parse(a.key) - int.parse(b.key));
          chat.conversation = Map.fromEntries(sortedConversation);
        }
        return chat; 
      });
  }
}