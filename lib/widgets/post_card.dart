import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLike = false;
  int _likesCount = 0;

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

  @override
  void initState() {
    super.initState();
    _fetchLikeStatus();
  }

  Future<void> _handleShowOtherProfile(BuildContext context) async {
    await context.read<UserProvider>().fetchByID(widget.post.uid);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileVisitScreen(mode: 'other'),
      ),
    );
  }

  Future<void> _fetchLikeStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final likeDoc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post.postID)
        .collection('likes')
        .doc(user.uid)
        .get();

    final likeCount = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.post.postID)
        .collection('likes')
        .count()
        .get();

    if (mounted) {
      setState(() {
        _isLike = likeDoc.exists;
        _likesCount = likeCount.count ?? 0;
      });
    }
  }

  Future<void> _handleLikes() async {
    try {
      setState(() {
        _isLike = !_isLike;
        _isLike ? _likesCount++ : _likesCount--;
      });
      final currentUser = context.read<UserProvider>().user;
      if (_isLike) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post.postID)
            .collection('likes')
            .doc(currentUser!.uid)
            .set({
              'uid': currentUser.uid,
              'username': currentUser.username,
              'createdAt': Timestamp.now(),
            });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post.postID)
            .collection('likes')
            .doc(currentUser!.uid)
            .delete();
      }
    } catch (e) {
      setState(() {
        _isLike = !_isLike;
        _isLike ? _likesCount++ : _likesCount--;
      });
      scaffoldMessage(context, "Something went wrong");
      return;
    }
  }
  //Future<void> show

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().user;
    final displayName = widget.post.uid == currentUser!.uid
        ? currentUser.fullName
        : widget.post.fullName;
    final displayUsername = widget.post.uid == currentUser.uid
        ? currentUser.username
        : widget.post.username;
    return GestureDetector(
      onTap: () {
        return FocusScope.of(context).unfocus();
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
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
                      _handleShowOtherProfile(context);
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
                          _handleShowOtherProfile(context);
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
              AppText(text: widget.post.content, textFontSize: 16),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: AppText(
                  text: _formatTime(widget.post.createdAt),
                  textColor: Colors.grey,
                  textFontSize: 14,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: _handleLikes,
                        onLongPress: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
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
                                  FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(widget.post.postID)
                                        .collection('likes')
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.deepPurple,
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: AppText(
                                            text: "Something went wrong",
                                          ),
                                        );
                                      }
                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        return Center(
                                          child: AppText(text: "No Likes"),
                                        );
                                      }

                                      return Expanded(
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            final data =
                                                snapshot.data!.docs[index]
                                                        .data()
                                                    as Map<String, dynamic>;

                                            return ListTile(
                                              leading: CircleAvatar(
                                                child: Icon(Icons.person),
                                              ),
                                              title: AppText(
                                                text: "@ ${data['username']}",
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: _isLike
                            ? Icon(
                                Icons.favorite_outlined,
                                color: Colors.red,
                                size: 33,
                              )
                            : Icon(
                                Icons.favorite_outline,
                                color: Colors.black,
                                size: 30,
                              ),
                      ),
                      SizedBox(width: 5),
                      AppText(text: _likesCount.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.comment_rounded),
                      ),
                      AppText(text: "Reply"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
