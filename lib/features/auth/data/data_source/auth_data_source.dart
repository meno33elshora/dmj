import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  AuthDataSource(this._firebaseAuth, this._firebaseFirestore);

//! Sign Up
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firebaseFirestore
          .collection("Users")
          .doc(
            userCredential.user!.uid,
          )
          .set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
          "username": username,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.message);
    }
  }

  //! sign in account
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.message);
    }
  }

  //! sign out account
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.message);
    }
  }
}
