import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';

class PostContent extends StatelessWidget {
  final PostModel post;
  const PostContent({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9,bottom: 3),
      child: AppText(text: post.content, textFontSize: 16),
    );
  }
}
