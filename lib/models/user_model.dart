import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String username;
  final String? bio;
  final DateTime createdAt;
  final double randomIndex;
  final String? photoUrl;
  final String? photoPublicId;
  final List<Map<String, dynamic>> followers;
  final List<Map<String, dynamic>> following;
  final int followersCount;
  final int followingCount;

  UserModel({
    required this.uid,
    required this.username,
    required this.fullName,
    this.bio,
    required this.createdAt,
    required this.randomIndex,
    this.photoUrl,
    this.photoPublicId,
    required this.followers,
    required this.following,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      randomIndex: json['randomIndex'] ?? Random().nextDouble(),
      photoUrl: json['photoUrl'],
      photoPublicId: json['photoPublicId'],
      followers: List<Map<String, dynamic>>.from(
        (json['followers'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      following: List<Map<String, dynamic>>.from(
        (json['following'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      followersCount: (json['followersCount'] ?? 0) as int,
      followingCount: (json['followingCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
      'randomIndex': randomIndex,
      'photoUrl': photoUrl,
      'photoPublicId': photoPublicId,
      'followers': followers,
      'following': following,
      'followersCount' : followersCount,
      'followingCount' : followingCount
    };
  }
}
