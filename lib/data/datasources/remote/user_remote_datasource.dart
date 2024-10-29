import 'package:doctor_appointment/core/utils/time_converter.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRemoteDatasource {
  late final FirebaseAuth _auth;
  late final DatabaseReference _userRef;

  UserRemoteDatasource () {
    _auth = FirebaseAuth.instance;
    _userRef = FirebaseDatabase.instance.ref('User');
  }

  Future<UserCredential> signUpWithEmailPassword({required String email, required String password}) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUser({required String uid, required String email, String? name}) {
    UserModel userModel = UserModel(uid: uid, email: email, name: name, create_at: TimeConverter.getCurrentTime());
    return _userRef.child(userModel.uid).set(userModel.toMap());
  }

  Future<UserModel?> getUserByUID(String uid) async {
    DataSnapshot snapshot = await _userRef.child(uid).get();
    if (!snapshot.exists || snapshot.value == null) return null;

    return UserModel.fromMap(snapshot.value as Map<Object?, Object?>);
  }

  Future<List<UserModel>?> getAllUsers() async {
    DataSnapshot snapshot = await _userRef.get();
    if (!snapshot.exists || snapshot.value == null) return null;

    Map<Object?, Object?> data = snapshot.value as Map<Object?, Object?>;
      List<UserModel> userList = [];
      data.forEach((key, value) {
        userList.add(UserModel.fromMap(value as Map<Object?, Object?>));
      });
    return userList;
  }

  Future<UserCredential> signInWithEmailPassword({required String email, required String password}) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(
      email: email);
  }
}