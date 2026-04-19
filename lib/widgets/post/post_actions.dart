import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/widgets/post/likes_bottom_sheet.dart';

class PostActions extends StatefulWidget {
  final PostModel post;
  const PostActions({super.key, required this.post});

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool isLiked = false;

  bool isLoading = false;

  int likesCount = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                
              },
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      LikesBottomSheet(postID: widget.post.postID),
                );
              },
              child: isLiked
                  ? Icon(Icons.favorite_outlined, color: Colors.red, size: 33)
                  : Icon(Icons.favorite_outline, color: Colors.black, size: 30),
            ),
            SizedBox(width: 5),
            AppText(text: likesCount.toString()),
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
