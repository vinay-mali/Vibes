import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  UserModel? _otherUser;
  UserModel? get otherUser => _otherUser;

  Future<void> fetchUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final data = doc.data();
    if (data != null) {
      _user = UserModel.fromMap(data);
      notifyListeners();
    }
  }

  Future<void> fetchByID(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final data = doc.data();
    if (data != null) {
      _otherUser = UserModel.fromMap(data);
      notifyListeners();
    }
  }
}
