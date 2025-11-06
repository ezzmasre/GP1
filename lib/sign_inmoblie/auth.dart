import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservce {
  // instane of firebase
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore stor = FirebaseFirestore.instance;
  User? getcurrentuser() {
    return auth.currentUser;
  }

  /// sighn in
  Future<UserCredential> sighinwith_eamil(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //// sign out
  Future<void> signout() async {
    return await auth.signOut();
  }

  ///// sign uu
  ///
  Future<UserCredential> sighnup_emailpassword(String email, password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //// stor in firestore
      ///
      stor.collection("Users").doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': email,
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  //// stor in firestore
}
