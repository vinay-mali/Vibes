import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';

class PostTime extends StatelessWidget {
  final PostModel post;
  const PostTime({super.key, required this.post});

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
    return Align(
      alignment: Alignment.centerRight,
      child: AppText(
        text: _formatTime(post.createdAt),
        textColor: Colors.grey,
        textFontSize: 14,
      ),
    );
  }
}
