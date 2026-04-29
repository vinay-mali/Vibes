import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/widgets/app_avatar.dart';
import 'package:vibes/widgets/app_text.dart';

class LikesBottomSheet extends StatefulWidget {
  final PostModel post;
  const LikesBottomSheet({super.key, required this.post});

  @override
  State<LikesBottomSheet> createState() => _LikesBottomSheetState();
}

class _LikesBottomSheetState extends State<LikesBottomSheet> {
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
              AppText(text: widget.post.likesCount.toString()),
              Icon(Icons.favorite, color: Colors.red),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.post.likedBy.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  await context.read<UserProvider>().getUserByID(
                    widget.post.likedBy[index]['uid'].toString(),
                  );
                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileVisitScreen(mode: 'other'),
                    ),
                  );
                },
                leading: AppAvatar(photoUrl: null),
                title: AppText(
                  text: "@${widget.post.likedBy[index]['username'].toString()}",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
