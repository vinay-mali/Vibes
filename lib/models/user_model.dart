import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String username;
  final String? bio;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.fullName,
    this.bio,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      username: json['username'],
      fullName: json['fullName'],
      bio: json['bio'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
