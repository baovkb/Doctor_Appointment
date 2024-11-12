import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? address;

  @HiveField(4)
  String? create_at;

  @HiveField(5)
  String? photoURL;

  @HiveField(6)
  List<String>? review_id;

  @HiveField(7)
  List<String>? appointment_id;

  @HiveField(8)
  List<String>? chat_id;

  UserModel({
    required this.uid, 
    this.email,
    this.name,
    this.address,
    this.create_at,
    this.photoURL,
    this.review_id,
    this.appointment_id,
    this.chat_id
  });

  UserModel.fromMap(Map<Object?, Object?> map): 
    this(
      uid: map['uid'] as String, 
      email: map['email'] as String?, 
      name: map['name'] as String?, 
      address: map['address'] as String?, 
      create_at: map['create_at'] as String?,
      photoURL: map['photoURL'] as String?,
      review_id: (map['review_id'] as List<Object?>?)?.cast<String>().toList(),
      appointment_id: (map['appointment_id'] as List<Object?>?)?.cast<String>().toList(),
      chat_id: (map['chat_id'] as List<Object?>?)?.cast<String>().toList()
    );

  UserModel.fromUserCredential(UserCredential userCredential):
    this(
      uid: userCredential.user!.uid,
      email: userCredential.user?.email,
      name: userCredential.user?.displayName,
    );

  Map<String, Object?> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'address': address,
      'create_at': create_at,
      'photoURL': photoURL,
      'review_id': review_id,
      'appointment_id': appointment_id,
      'chat_id': chat_id
    }; 
  }
}