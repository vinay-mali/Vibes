import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';

import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/widgets/app_avatar.dart';
import 'package:vibes/widgets/app_text.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;
  const PostHeader({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            await context.read<UserProvider>().getUserByID(post.uid);
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileVisitScreen(mode: 'other', post: post),
              ),
            );
          },
          child: AppAvatar(photoUrl: post.photoUrl),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: post.fullName,
              textFontWeight: FontWeight.w600,
              textFontSize: 16,
            ),

            AppText(
              text: "@${post.username}",
              textColor: Colors.grey,
              textFontSize: 13,
            ),
          ],
        ),
      ],
    );
  }
}
