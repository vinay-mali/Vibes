import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/services/cloudinary_service.dart';

class PostService {
  final CloudinaryService _cloudinaryService = CloudinaryService();
  Future<void> createPost(PostModel postModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postModel.postID)
          .set(postModel.toMap());
    } catch (e) {
      throw "Unable to post. Try again.";
    }
  }

  Future<String> currentPostID() async {
    final postID = await FirebaseFirestore.instance
        .collection('posts')
        .doc()
        .id;
    return postID;
  }

  Stream<QuerySnapshot> getPost() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> likePost(String postID, String uid, String username) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postID).update({
        'likesCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([
          {'uid': uid, 'username': username},
        ]),
      });
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> unlikePost(String postID, String uid, String username) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postID).update({
        'likesCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([
          {'uid': uid, 'username': username},
        ]),
      });
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<List<Map<String, String>>> uploadPostPhoto(
    List<File> imageFiles,
  ) async {
    try {
      final result = await _cloudinaryService.uploadMultiplePhotos(
        imageFiles,
        'posts',
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
