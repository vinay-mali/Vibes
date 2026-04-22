import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/post_provider.dart';
import 'package:vibes/providers/user_provider.dart';

import 'package:vibes/screens/add_post_screen.dart';
import 'package:vibes/screens/profile_visit_screen.dart';
import 'package:vibes/screens/settings_screen.dart';
import 'package:vibes/screens/splash_screen.dart';

import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/widgets/post/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
    context.read<UserProvider>().fetchCurrentUser()
  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Vibes"),
        backgroundColor: Colors.transparent,
        actions: [
          CircleAvatar(
            child: IconButton(
              onPressed: () async {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileVisitScreen(mode: 'user'),
                    ),
                  );
                }
              },
              icon: Icon(Icons.person),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E8FF), Color(0xFFEDE9FE)],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: context.read<PostProvider>().getPost(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: AppText(text: "No posts yet. Be the first!"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = PostModel.fromMap(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>,
                  );
                  return PostCard(post: post);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
