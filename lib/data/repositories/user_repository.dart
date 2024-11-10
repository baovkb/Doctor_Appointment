import 'package:dartz/dartz.dart';
import 'package:doctor_appointment/core/resources/strings.dart';
import 'package:doctor_appointment/core/utils/failure.dart';
import 'package:doctor_appointment/core/utils/locator.dart';
import 'package:doctor_appointment/data/datasources/remote/user_remote_datasource.dart';
import 'package:doctor_appointment/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class UserRepository {
  late final UserRemoteDatasource _datasource;
  late final Box<UserModel> _userBox;

  UserRepository() {
    _datasource = locator.get<UserRemoteDatasource>();
    _userBox = locator.get<Box<UserModel>>();
  }

  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      UserCredential user = await _datasource.signInWithEmailPassword(email: email, password: password);
      final either = await getUserByUID(user.user!.uid);
      either.foldRight(null, (userModel, b) {
        _userBox.put(user.user!.uid, userModel);
      });
      
      return Right(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return const Left(AuthenticationFailure(AppStrings.invalidEmail));
        case 'user-disabled':
          return const Left(AuthenticationFailure(AppStrings.userDisabled));
        case 'user-not-found':
          return const Left(AuthenticationFailure(AppStrings.userNotFound));
        case 'wrong-password':
        case 'INVALID_LOGIN_CREDENTIALS':
        case 'invalid-credential':
          return const Left(AuthenticationFailure(AppStrings.passwordNotMatch));
        case 'too-many-requests':
          return const Left(AuthenticationFailure(AppStrings.manyRequest));
        case 'user-token-expired':
          return const Left(AuthenticationFailure(AppStrings.tokenExpired));
        case 'network-request-failed':
          return const Left(NetworkFailure(AppStrings.noInternet));
        case 'operation-not-allowed':
          return const Left(AuthenticationFailure(AppStrings.operationEmailPassNotAllow));
        default: return const Left(AuthenticationFailure(AppStrings.unexpectedError)); 
      }
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, UserCredential>> signUpWithEmailPassword({required String email, required String password, String? name}) async {
    try {
      UserCredential user = await _datasource.signUpWithEmailPassword(email: email, password: password);
      await _datasource.createUser(uid: user.user!.uid, email: email, name: name);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return const Left(AuthenticationFailure(AppStrings.emailInUse));
        case 'invalid-email':
          return const Left(AuthenticationFailure(AppStrings.invalidEmail));
        case 'operation-not-allowed':
          return const Left(AuthenticationFailure(AppStrings.operationEmailPassNotAllow));
        case 'weak-password':
          return const Left(AuthenticationFailure(AppStrings.passwordWeak));
        case 'network-request-failed':
          return const Left(NetworkFailure(AppStrings.noInternet));
        case 'too-many-requests':
          return const Left(AuthenticationFailure(AppStrings.manyRequest));
        case 'user-token-expired':
          return const Left(AuthenticationFailure(AppStrings.tokenExpired));
        default: return const Left(AuthenticationFailure(AppStrings.unexpectedError));
      }
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<bool> emailExist(String email) async {
    List<UserModel>? allUsers = await _datasource.getAllUsers();
    if (allUsers == null) return false;

    for (UserModel user in allUsers) {
      if (user.email == email) return true;
    }

    return false;
  }

  Future<void> signOut() {
    return _datasource.signOut();
  }

  Future<Either<Failure, bool>> sendPasswordResetEmail(String email) async {
    try {
      await _datasource.sendPasswordResetEmail(email);
      return const Right(true);
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'auth/invalid-email':
          return const Left(AuthenticationFailure(AppStrings.invalidEmail));
        case 'auth/user-not-found':
          return const Left(AuthenticationFailure(AppStrings.userNotFound));
        default:
          return const Left(UnexpectedFailure(AppStrings.unexpectedError));
      }
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, UserModel>> getUserByUID(String uid) async {
    try {
      UserModel? user = await _datasource.getUserByUID(uid);
      return user == null ? const Left(DataNotFoundFailure(AppStrings.dataNotFound)) : Right(user);
    } catch (e) {
      return const Left(UnexpectedFailure(AppStrings.unexpectedError));
    }
  }

  Future<Either<Failure, UserModel>> getCurrentUser({bool forceUpdate = false}) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Left(AuthenticationFailure(AppStrings.userNotSignin));

    UserModel? userModel = forceUpdate ? null : _userBox.get(uid);
    if (userModel == null) {
      final either =  await getUserByUID(uid);
      return await either.fold(
        (failure) => Left(failure), 
        (user) async {
          await _userBox.put(uid, user);
          return Right(user);
        }
      );
    } else return Right(userModel);
  }

  Future<Either<Failure, void>> updateUser(UserModel user) async {
    try {
      await _datasource.updateUser(user);
      await _userBox.put(user.uid, user);
      return Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}