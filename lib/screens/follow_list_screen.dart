import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/user_model.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';

class FollowListScreen extends StatefulWidget {
  final String mode;
  final UserModel user;
  const FollowListScreen({super.key, required this.mode, required this.user});

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.mode == 'follower') {
      if (widget.user.followers.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: Text("Followers")),
          body: Center(child: AppText(text: "No followers")),
        );
      }
    }
    if (widget.mode == 'following') {
      if (widget.user.following.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: Text("Following")),
          body: Center(child: AppText(text: "No following")),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == 'follower' ? "Followers" : "Following"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.mode == 'follower'
              ? widget.user.followers.length
              : widget.user.following.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                onTap: () async {
                  if (widget.mode == 'follower') {
                    await context.read<UserProvider>().getUserByID(
                      widget.user.followers[index]['uid'],
                    );
                  } else {
                    await context.read<UserProvider>().getUserByID(
                      widget.user.following[index]['uid'],
                    );
                  }

                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileVisitScreen(mode: 'other'),
                    ),
                  );
                },
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: AppText(
                  text: widget.mode == 'follower'
                      ? "@${widget.user.followers[index]['username']}"
                      : "@${widget.user.following[index]['username']}",
                ),
                trailing:
                    widget.mode == 'follower' &&
                        context.read<UserProvider>().currentuserModel!.uid ==
                            widget.user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                    title: AppText(
                                      text:
                                          "Are you sure to remove it as follower?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: AppText(text: "Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () async {
                                                setDialogState(() {
                                                  isLoading = true;
                                                });
                                                await context
                                                    .read<UserProvider>()
                                                    .getUserByID(
                                                      widget
                                                          .user
                                                          .followers[index]['uid'],
                                                    );
                                                final currentUser = context
                                                    .read<UserProvider>()
                                                    .currentuserModel;
                                                final visitedUser = context
                                                    .read<UserProvider>()
                                                    .visitedUserModel;
                                                if (currentUser == null ||
                                                    visitedUser == null) {
                                                  scaffoldMessage(
                                                    context,
                                                    "User not found",
                                                  );
                                                  return;
                                                }
                                                try {
                                                  await context
                                                      .read<UserProvider>()
                                                      .removeFollower(
                                                        currentUser.uid,
                                                        currentUser.username,
                                                        visitedUser.username,
                                                        visitedUser.uid,
                                                      );
                                                  await context
                                                      .read<UserProvider>()
                                                      .fetchCurrentUser();

                                                  await context
                                                      .read<UserProvider>()
                                                      .getUserByID(
                                                        visitedUser.uid,
                                                      );
                                                } catch (e) {
                                                  scaffoldMessage(
                                                    context,
                                                    e.toString(),
                                                  );
                                                } finally {
                                                  setDialogState(() {
                                                    isLoading = false;
                                                  });
                                                  setState(() {});
                                                  if (!mounted) return;
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: isLoading
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color:
                                                            Colors.deepPurple,
                                                      ),
                                                ),
                                              )
                                            : AppText(
                                                text: "Remove",
                                                textColor: Colors.white,
                                              ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.close),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
