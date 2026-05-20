import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/post_provider.dart';

import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/follow_list_screen.dart';
import 'package:vibes/screens/profile_set_screen.dart';
import 'package:vibes/screens/settings_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_avatar.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/widgets/post/post_card.dart';

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
  bool isDialogButtonLoading = false;
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [AppAvatar(photoUrl: user.photoUrl, radius: 100)],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AppText(
                      text: user.fullName,
                      textFontSize: 25,
                      textFontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    child: AppText(text: user.bio ?? "", textFontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowListScreen(
                                    mode: 'follower',
                                    user: user,
                                  ),
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
                                  builder: (context) => FollowListScreen(
                                    mode: 'following',
                                    user: user,
                                  ),
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
                                textColor: isFollowing
                                    ? Colors.black
                                    : Colors.white,
                                textFontWeight: FontWeight.w500,
                                textFontSize: 16,
                              ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      child: AppText(
                        text: "Posts",
                        textFontSize: 18,
                        textFontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<List<PostModel>>(
              stream: context.read<PostProvider>().getPostsOnProfile(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: AppText(text: "Something went wrong")),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: AppText(text: "No posts yet")),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => InkWell(
                      onLongPress: widget.mode == 'user'
                          ? () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setDialogState) => AlertDialog(
                                      title: AppText(text: "Delete this post?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: AppText(
                                            text: "no",
                                            textColor: Colors.black,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: isDialogButtonLoading
                                              ? null
                                              : () async {
                                                  setDialogState(() {
                                                    isDialogButtonLoading =
                                                        true;
                                                  });
                                                  try {
                                                    await context
                                                        .read<PostProvider>()
                                                        .deleteUserPost(
                                                          snapshot
                                                              .data![index]
                                                              .postID,
                                                        );

                                                    setDialogState(() {
                                                      isDialogButtonLoading =
                                                          false;
                                                    });
                                                    if (!mounted) return;
                                                    Navigator.pop(context);
                                                  } catch (e) {
                                                    if (!mounted) return;
                                                    Navigator.pop(context);
                                                    scaffoldMessage(
                                                      context,
                                                      e.toString(),
                                                    );
                                                  } finally {
                                                    setDialogState(() {
                                                      isDialogButtonLoading =
                                                          false;
                                                    });
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: isDialogButtonLoading
                                              ? SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                )
                                              : AppText(
                                                  text: "Yes",
                                                  textColor: Colors.white,
                                                ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          : null,
                      child: PostCard(post: snapshot.data![index]),
                    ),
                    childCount: snapshot.data!.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
