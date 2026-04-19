import 'package:flutter/material.dart';
import 'package:vibes/widgets/app_text.dart';

class LikesBottomSheet extends StatelessWidget {
  final String postID;
  const LikesBottomSheet({super.key,required this.postID});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: AppText(
            text: "Likes",
            textFontSize: 20,
            textFontWeight: FontWeight.w500,
          ),
        ),
        
      ],
    );
  }
}
