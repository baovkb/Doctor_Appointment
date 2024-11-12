import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/data/models/chat_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRemoteDatasource {
  late final DatabaseReference _chatRef;

  ChatRemoteDatasource() {
    _chatRef = FirebaseDatabase.instance.ref('Chat');
  }

  Future<ChatModel?> getChatByID(String id) async {
    DataSnapshot snapshot = await _chatRef.child(id).get();
    if (!snapshot.exists || snapshot.value == null) return null;
    
    return ChatModel.fromMap(snapshot.value! as Map<Object?, Object?>);
  }

  Future<ChatModel> addChat({required String uid, required String doctor_id}) async {
    String key = _chatRef.push().key!;
    ChatModel chat = ChatModel(
      id: key, 
      uid: uid, 
      doctor_id: doctor_id, 
      conversation: null);

    await _chatRef.child(key).set(chat.toMap());
    return chat;
  }

  Future<void> sendMessage(String chat_id, ChatMessage chatMessage) async {
    DatabaseReference chatMessRef = _chatRef.child(chat_id);
    DataSnapshot snapshot = await chatMessRef.get();
    
    if (!snapshot.exists) throw DataNotFoundFailure(AppStrings.chatNotFound);
    return chatMessRef.child('conversation').child(chatMessage.time).set(chatMessage.toMap());
  }

  Stream<ChatModel> getChatStream(String id) {
    return _chatRef.child(id).onValue.map((event) {
      final map = event.snapshot.value as Map<Object?, Object?>;
      return ChatModel.fromMap(map);
    },);
  }
}