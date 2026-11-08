import 'package:flutter/material.dart';
import 'package:insta_flutter/models/user.dart';
import 'package:insta_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  final AuthMethods _authMethods = AuthMethods();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}