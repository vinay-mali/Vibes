import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postID;
  final String content;
  final DateTime createdAt;
  final String uid;
  final String username;
  final String fullName;

  PostModel({
    required this.postID,
    required this.content,
    required this.createdAt,
    required this.uid,
    required this.username,
    required this.fullName,
    
  });

  factory PostModel.fromMap(Map<String, dynamic> json) {
    return PostModel(
      postID: json['postID'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      uid: json['uid'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'uid': uid,
      'fullName' : fullName,
      'username' : username
    };
  }
}
