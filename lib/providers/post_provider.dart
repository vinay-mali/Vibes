import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> createPost(PostModel postModel) async {
    try {
      await _postService.createPost(postModel);
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getPost() {
    return _postService.getPost();
  }

  Future<void> likePost(String postID, String username, String uid) async {
    try {
      await _postService.likePost(postID, username, uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postID, String uid) async {
    try {
      await _postService.unlikePost(postID, uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> likesCount(String postID) async {
    try {
      final count = await _postService.likesCount(postID);
      notifyListeners();
      return count;
    } catch (e) {
      rethrow;
    }
  }
}
