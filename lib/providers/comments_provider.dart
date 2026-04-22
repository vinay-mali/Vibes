import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/comments_model.dart';
import 'package:vibes/services/comments_service.dart';

class CommentsProvider extends ChangeNotifier {
  final CommentsService _commentsService = CommentsService();

  Future<void> createComment(CommentsModel commentModel, String postID) async {
    try {
      await _commentsService.createComment(commentModel, postID);
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getComment(String postID) {
    return _commentsService.getComment(postID);
  }
}
