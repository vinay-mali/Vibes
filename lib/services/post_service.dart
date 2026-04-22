import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibes/models/post_model.dart';

class PostService {
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

  
}
