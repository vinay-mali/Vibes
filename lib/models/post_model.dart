import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postID;
  final String content;
  final DateTime createdAt;
  final String username;
  final String fullName;
  final String uid;

  PostModel({
    required this.postID,
    required this.content,
    required this.createdAt,
    required this.username,
    required this.fullName,
    required this.uid,
  });

  factory PostModel.fromMap(Map<String, dynamic> json) {
    return PostModel(
      postID: json['postID'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      uid: json['uid'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'username': username,
      'fullName': fullName,
      'uid' : uid
    };
  }
}
