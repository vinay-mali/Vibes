import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/post_provider.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/screens/comments_screen.dart';
import 'package:vibes/widgets/post/likes_bottom_sheet.dart';

class PostActions extends StatefulWidget {
  final PostModel post;
  const PostActions({super.key, required this.post});

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  Widget build(BuildContext context) {
    final userModel = context.watch<UserProvider>().currentuserModel;
    final isLiked =
        userModel != null &&
        widget.post.likedBy.any((e) => e['uid'] == userModel.uid);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                if (userModel == null) return;
                try {
                  if (isLiked) {
                    await context.read<PostProvider>().unlikePost(
                      widget.post.postID,
                      userModel.uid,
                      userModel.username,
                    );
                  } else {
                    await context.read<PostProvider>().likePost(
                      widget.post.postID,
                      userModel.uid,
                      userModel.username,
                    );
                  }
                } catch (e) {
                  if (mounted) scaffoldMessage(context, e.toString());
                }
              },
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => LikesBottomSheet(post: widget.post),
                );
              },
              child:
                  Icon(
                        isLiked
                            ? Icons.favorite_outlined
                            : Icons.favorite_outline,
                        color: isLiked ? Colors.red : Colors.black,
                        size: isLiked ? 28 : 25,
                      )
                      .animate(target: isLiked ? 1.0 : 0.0)
                      .scale(
                        begin: Offset(1.0, 1.0),
                        end: Offset(1.3, 1.3),
                        duration: 150.ms,
                        curve: Curves.easeOut,
                      )
                      .then()
                      .scale(
                        begin: Offset(1.3, 1.3),
                        end: Offset(1.0, 1.0),
                        duration: 150.ms,
                        curve: Curves.easeIn,
                      ),
            ),
            SizedBox(width: 5),
            AppText(text: widget.post.likesCount.toString()),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(post: widget.post),
                  ),
                );
              },
              icon: Icon(Icons.comment_rounded),
            ),
            AppText(text: widget.post.commentsCount.toString()),
          ],
        ),
      ],
    );
  }
}
