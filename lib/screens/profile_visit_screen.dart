import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';

import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/follow_list_screen.dart';
import 'package:vibes/screens/profile_set_screen.dart';
import 'package:vibes/screens/settings_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_avatar.dart';
import 'package:vibes/widgets/app_text.dart';

class ProfileVisitScreen extends StatefulWidget {
  final String mode;
  final PostModel? post;
  const ProfileVisitScreen({super.key, required this.mode, this.post});
  @override
  State<ProfileVisitScreen> createState() => _ProfileVisitScreenState();
}

class _ProfileVisitScreenState extends State<ProfileVisitScreen> {
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    final currentUser = context.read<UserProvider>().currentuserModel;
    final visitedUser = context.read<UserProvider>().visitedUserModel;
    if (currentUser != null && visitedUser != null) {
      isFollowing = currentUser.following.any(
        (e) => e['uid'] == visitedUser.uid,
      );
    }
  }

  void handleFollow() async {
    final currentUser = context.read<UserProvider>().currentuserModel;
    final visitedUser = context.read<UserProvider>().visitedUserModel;
    if (currentUser == null || visitedUser == null) {
      scaffoldMessage(context, "User not found");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      if (isFollowing) {
        await context.read<UserProvider>().unfollowUser(
          currentUser.uid,
          currentUser.username,
          visitedUser.username,
          visitedUser.uid,
        );
      } else {
        await context.read<UserProvider>().followUser(
          currentUser.uid,
          currentUser.username,
          visitedUser.username,
          visitedUser.uid,
        );
      }
      await context.read<UserProvider>().fetchCurrentUser();
      await context.read<UserProvider>().getUserByID(visitedUser.uid);

      setState(() {
        isFollowing = !isFollowing;
      });

    } catch (e) {
      scaffoldMessage(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.mode == 'user'
        ? context.watch<UserProvider>().currentuserModel
        : context.watch<UserProvider>().visitedUserModel;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: user.username, textFontSize: 18),
        actions: [
          if (widget.mode == 'user')
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSetScreen(mode: 'edit'),
                    ),
                  );
                },
                icon: Icon(Icons.edit, size: 30),
              ),
            ),
          if (widget.mode == 'user')
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                icon: Icon(Icons.menu),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [AppAvatar(photoUrl: user.photoUrl, radius: 100)],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AppText(
                text: user.fullName,
                textFontSize: 25,
                textFontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: AppText(text: user.bio ?? "", textFontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FollowListScreen(mode: 'follower', user: user,),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: user.followersCount.toString(),
                          textFontSize: 17,
                          textFontWeight: FontWeight.w600,
                        ),
                        AppText(text: "followers"),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FollowListScreen(mode: 'following', user: user),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        AppText(
                          text: user.followingCount.toString(),
                          textFontSize: 17,
                          textFontWeight: FontWeight.w600,
                        ),
                        AppText(text: "following"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (widget.mode == 'other' &&
                context.read<UserProvider>().visitedUserModel!.uid !=
                    context.read<UserProvider>().currentuserModel!.uid)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Colors.grey.shade300
                        : Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.black,
                    fixedSize: Size(130, 40),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                      : AppText(
                          text: isFollowing ? "Following" : "Follow",
                          textColor: isFollowing ? Colors.black : Colors.white,
                          textFontWeight: FontWeight.w500,
                          textFontSize: 16,
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
