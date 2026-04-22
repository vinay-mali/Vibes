import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  final String commentID;
  final String content;
  final String uid;
  final String username;
  final String fullName;
  final DateTime createdAt;

  CommentsModel({
    required this.commentID,
    required this.content,
    required this.uid,
    required this.username,
    required this.fullName,
    required this.createdAt,
  });

  factory CommentsModel.fromMap(Map<String, dynamic> json) {
    return CommentsModel(
      commentID: json['commentID'] ?? "",
      content: json['content'] ?? "",
      uid: json['uid'] ?? "",
      username: json['username'] ?? "",
      fullName: json['fullName'] ?? "",
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentID': commentID,
      'content': content,
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
