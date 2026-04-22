import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();

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

  Future<void> likePost(String postID, String uid, String username) async {
    try {
      await _postService.likePost(postID, uid, username);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postID, String uid, String username) async {
    try {
      await _postService.unlikePost(postID, uid,username);
    } catch (e) {
      rethrow;
    }
  }

  
}
