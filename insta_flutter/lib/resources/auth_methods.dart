import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:insta_flutter/resources/storage_methods.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoURL = await StorageMethods().uploadImagetoStorage("profilepics", file, false);
        //add user to database
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'username': userName,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoURL': photoURL,
        });


        return "success";
      } else {
        return "failed";
      }
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
  
  //logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //register user
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return "success";
      } else {
        return "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
