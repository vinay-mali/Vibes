import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/utils/helpers.dart';
class PostTime extends StatelessWidget {
  final PostModel post;
  const PostTime({super.key, required this.post});

  

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: AppText(
        text: formatTime(post.createdAt),
        textColor: Colors.grey,
        textFontSize: 14,
      ),
    );
  }
}
