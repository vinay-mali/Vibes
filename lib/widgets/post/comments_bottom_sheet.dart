import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/comments_model.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/comments_provider.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/widgets/post/post_content.dart';
import 'package:vibes/widgets/post/post_header.dart';
import 'package:vibes/widgets/post/post_time.dart';

class CommentsBottomSheet extends StatefulWidget {
  final PostModel post;
  const CommentsBottomSheet({super.key, required this.post});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  TextEditingController commentCtrl = TextEditingController();

  Future<void> handleComments() async {
    try {
      final commentID = FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.postID)
          .collection('comments')
          .doc()
          .id;

      final currentUser = context.read<UserProvider>().currentuserModel;
      if (commentCtrl.text.trim().isEmpty) {
        scaffoldMessage(context, "Please write something.");
        return;
      }
      if (currentUser == null) return;

      final CommentsModel commentsModel = CommentsModel(
        commentID: commentID,
        content: commentCtrl.text.trim(),
        uid: currentUser.uid,
        username: currentUser.username,
        fullName: currentUser.fullName,
        createdAt: DateTime.now(),
      );

      await context.read<CommentsProvider>().createComment(
        commentsModel,
        widget.post.postID,
      );
      if (!mounted) return;
      commentCtrl.clear();
    } catch (e) {
      if (mounted) scaffoldMessage(context, e.toString());
    }
  }

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 34,
              left: 8,
              right: 8,
              bottom: 5,
            ),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostHeader(post: widget.post),
                    PostContent(post: widget.post),
                    PostTime(post: widget.post),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        AppText(text: "${widget.post.likesCount}"),
                        SizedBox(width: 15),
                        Icon(Icons.comment, color: Colors.purple),
                        AppText(text: "${widget.post.commentsCount}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: AppText(
              text: "Comments",
              textFontSize: 20,
              textFontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 17),
          StreamBuilder<QuerySnapshot>(
            stream: context.read<CommentsProvider>().getComment(
              widget.post.postID,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      AppText(text: "Something went wrong"),
                      SizedBox(height: 40),
                    ],
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      AppText(text: "No comments yet"),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.black, thickness: 1);
                  },
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final comment = CommentsModel.fromMap(
                      snapshot.data!.docs[index].data() as Map<String, dynamic>,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                        top: 5,
                        left: 15,
                        right: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(child: Icon(Icons.person)),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: comment.fullName,
                                      textFontSize: 15,
                                      textFontWeight: FontWeight.w500,
                                    ),
                                    AppText(
                                      text: comment.username,
                                      textColor: Colors.grey,
                                      textFontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: AppText(
                                  text: formatTime(comment.createdAt),
                                  textColor: Colors.grey,
                                  textFontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 6,
                              left: 3,
                              right: 3,
                            ),
                            child: AppText(
                              text: comment.content,
                              textFontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: commentCtrl,
              decoration: InputDecoration(
                labelText: "Reply",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: handleComments,

                  icon: Icon(Icons.send_outlined, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
