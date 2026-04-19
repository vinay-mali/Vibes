import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/user_model.dart';
import 'package:vibes/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _userModel;
  UserModel? get userModel => _userModel;



  User? getCurrentUser() {
    return _userService.getCurrentUser();
  }

  Future<void> createUser(String uid, UserModel userModel) async {
    try {
      await _userService.createUser(uid, userModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserByID(String uid) async {
    try {
      final user = await _userService.getUserByID(uid);
      _userModel = user;
      notifyListeners();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String uid, UserModel userModel) async {
    try {
      await _userService.updateUser(uid, userModel);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    return await _userService.isUsernameTaken(username);
  }
}
