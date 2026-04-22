import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/user_model.dart';
import 'package:vibes/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _currentUserModel;
  UserModel? get currentuserModel => _currentUserModel;

  UserModel? _visitedUserModel;
  UserModel? get visitedUserModel => _visitedUserModel;

  User? getCurrentUser() {
    return _userService.getCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
  try {
    final user = getCurrentUser();
    if (user == null) return;
    _currentUserModel = await _userService.getUserByID(user.uid);
    notifyListeners();
  } catch (e) {
    rethrow;
  }
}

  Future<UserModel> getUserByID(String uid) async {
    try {
      final user = await _userService.getUserByID(uid);
      _visitedUserModel = user;
      notifyListeners();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(String uid, UserModel userModel) async {
    try {
      await _userService.createUser(uid, userModel);
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
