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
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (!doc.exists) {
        throw "User not found";
      }
      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      throw "Failed to fetch user";
    }
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
}
