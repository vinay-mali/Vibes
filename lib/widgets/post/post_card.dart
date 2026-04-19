
import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/post/post_actions.dart';
import 'package:vibes/widgets/post/post_content.dart';
import 'package:vibes/widgets/post/post_header.dart';
import 'package:vibes/widgets/post/post_time.dart';


class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        return FocusScope.of(context).unfocus();
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(post: widget.post),
              PostContent(post: widget.post),
              PostTime(post: widget.post),
              PostActions(post: widget.post),
                           
              
            ],
          ),
        ),
      ),
    );
  }
}
