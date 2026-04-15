import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/widgets/app_text.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

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

  Future<void> handleShowOtherProfile(BuildContext context) async {
    await context.read<UserProvider>().fetchByID(post.uid);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileVisitScreen(mode: 'other'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;
    final displayName = post.uid == currentUser!.uid
        ? currentUser.fullName
        : post.fullName;
    final displayUsername = post.uid == currentUser.uid
        ? currentUser.username
        : post.username;
    return Card(
      elevation: 2,
      color: const Color.fromARGB(255, 243, 236, 255),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    handleShowOtherProfile(context);
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.person,
                      color: Colors.deepPurple.shade300,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        handleShowOtherProfile(context);
                      },
                      child: AppText(
                        text: displayName,
                        textFontWeight: FontWeight.w600,
                        textFontSize: 16,
                      ),
                    ),
                    AppText(
                      text: "@${displayUsername}",
                      textColor: Colors.grey,
                      textFontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            AppText(text: post.content, textFontSize: 16),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: AppText(
                text: _formatTime(post.createdAt),
                textColor: Colors.grey,
                textFontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
