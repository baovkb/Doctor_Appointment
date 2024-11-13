// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  String id;
  String uid;
  String doctor_id;
  List<ChatMessage>? conversation;

  ChatModel({
    required this.id,
    required this.uid,
    required this.doctor_id,
    required this.conversation
  });

  ChatModel.fromMap(Map<Object?, Object?> map): this(
    id: map['id'] as String,
    uid: map['uid'] as String,
    doctor_id: map['doctor_id'] as String,
    conversation: (map['conversation'] as Map<Object?, Object?>?)?.values.map(
      (e) => ChatMessage.fromMap(e as Map<Object?, Object?>)
    ).toList()
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'uid': uid,
      'doctor_id': doctor_id,
      if (conversation != null) 'conversation':  Map.fromEntries(conversation!.map(
        (e) => MapEntry(e.time, e.toMap()))
      )
    };
  }
}

class ChatMessage {
  String sender_id;
  String message;
  String time; //primary key

  ChatMessage({
    required this.sender_id,
    required this.message,
    required this.time,
  });

  ChatMessage.fromMap(Map<Object?, Object?> map): this(
    sender_id: map['sender_id'] as String,
    message: map['message'] as String,
    time: map['time'] as String,
  );

  Map<String, Object?> toMap() {
    return {
      'sender_id': sender_id,
      'message': message,
      'time': time,
    };
  }
}
