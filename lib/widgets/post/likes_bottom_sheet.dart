import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/widgets/app_text.dart';

class LikesBottomSheet extends StatelessWidget {
  final PostModel post;
  const LikesBottomSheet({super.key, required this.post});
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(text: post.likesCount.toString()),
              Icon(Icons.favorite, color: Colors.red),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: post.likedBy.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: AppText(
                  text: "@${post.likedBy[index]['username'].toString()}",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
