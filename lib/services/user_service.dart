import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibes/models/user_model.dart';

class UserService {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> createUser(String uid, UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userModel.toMap());
    } catch (e) {
      throw "Unable to create user.";
    }
  }

  Future<UserModel> getUserByID(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (!doc.exists) {
      throw "User not found";
    }
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(String uid, UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(userModel.toMap());
    } catch (e) {
      throw "Failed to update user.";
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<UserModel>> searchUser(String query) async {
    try {
      final byUsername = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .limit(10)
          .get();

      return byUsername.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw "User not found";
    }
  }

  Future<List<UserModel>> fetchRandomUsers() async {
    try {
      final random = Random().nextDouble();
      final currentUID = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("randomIndex", isGreaterThan: random)
          .limit(6)
          .get();
      List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .where((u) => u.uid != currentUID)
          .toList();

      if (users.length < 6) {
        final secondSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("randomIndex", isLessThanOrEqualTo: random)
            .limit(6 - users.length)
            .get();
        users.addAll(
          secondSnapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .where((u) => u.uid != currentUID)
              .toList(),
        );
      }
      return users;
    } catch (e) {
      throw "";
    }
  }
}
