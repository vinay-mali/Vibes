import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/post_provider.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/widgets/post/likes_bottom_sheet.dart';

class PostActions extends StatefulWidget {
  final PostModel post;
  const PostActions({super.key, required this.post});

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  void initState() {
    super.initState();
  }

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
              child: isLiked
                  ? Icon(Icons.favorite_outlined, color: Colors.red, size: 33)
                  : Icon(Icons.favorite_outline, color: Colors.black, size: 30),
            ),
            SizedBox(width: 5),
            AppText(text: widget.post.likesCount.toString()),
          ],
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.comment_rounded)),
            AppText(text: "Reply"),
          ],
        ),
      ],
    );
  }
}
