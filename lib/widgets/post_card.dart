import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';

class PostCard extends StatelessWidget{
  final PostModel post;
  const PostCard({super.key,required this.post});

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) {
      return "Just now";
    }
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    }
    if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    }
    if (diff.inDays < 7) {
      return "${diff.inDays}d ago";
    }
    return "${time.day}/${time.month}/${time.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(child: Icon(Icons.person),),
              SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: post.fullName,
                    textFontWeight: FontWeight.bold,
                    textFontSize: 17,
                  ),
                  AppText(
                    text: "@${post.username}",
                    textColor: Colors.grey,
                    textFontSize: 15,
                  ),
                ],
              ),
            ],
          ),
          AppText(text: post.content, textFontSize: 16),
          AppText(
            text: _formatTime(post.createdAt),
            textColor: Colors.grey,
            textFontSize: 15,
          ),
        ],
      ),
    );
  }
}
