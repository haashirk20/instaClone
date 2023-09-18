import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AuthMethods{
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

      if (email.isNotEmpty || password.isNotEmpty || userName.isNotEmpty || bio.isNotEmpty || file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        //add user to database

      } else {
        return "failed";
      }
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}