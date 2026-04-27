import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postID;
  final String content;
  final DateTime createdAt;
  final String uid;
  final String username;
  final String fullName;
  final int likesCount;
  final List<Map<String, dynamic>> likedBy;
  final int commentsCount;

  PostModel({
    required this.postID,
    required this.content,
    required this.createdAt,
    required this.uid,
    required this.username,
    required this.fullName,
    required this.likesCount,
    required this.likedBy,
    required this.commentsCount,
  });

  factory PostModel.fromMap(Map<String, dynamic> json) {
    return PostModel(
      postID: json['postID'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      uid: json['uid'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      likesCount: (json['likesCount'] ?? 0) as int,
      likedBy: List<Map<String, dynamic>>.from(
        (json['likedBy'] as List? ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      commentsCount: (json['commentsCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'likesCount': likesCount,
      'likedBy': likedBy,
      'commentsCount': commentsCount,
    };
  }
}
