import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibes/models/comments_model.dart';

class CommentsService {
  Future<void> createComment(CommentsModel commentModel, String postID) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postID)
          .collection('comments')
          .doc(commentModel.commentID)
          .set(commentModel.toMap());

      await FirebaseFirestore.instance.collection('posts').doc(postID).update({
        'commentsCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw "Something went wrong. Try again";
    }
  }

  Stream<QuerySnapshot> getComment(String postID) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('comments')
        .orderBy('createdAt')
        .snapshots();
  }
}
