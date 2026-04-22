import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';

class CommentsBottomSheet extends StatelessWidget {
  final PostModel post;
  const CommentsBottomSheet({super.key,required this.post});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppText(
            text: "Comments",
            textFontSize: 20,
            textFontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
