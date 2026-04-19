import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibes/models/post_model.dart';

class PostService {
  Future<void> createPost(PostModel postModel,) async {
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
  

  Future<void> likePost(String postID, String username, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .collection('likes')
          .doc(uid)
          .set({
            'uid': uid,
            'createdAt': Timestamp.now(),
            'username': username,
          });
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<void> unlikePost(String postID, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .collection('likes')
          .doc(uid)
          .delete();
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<int> likesCount(String postID) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .collection('likes')
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      throw "Something went wrong";
    }
  }
}
