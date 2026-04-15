import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/profile_set_screen.dart';
import 'package:vibes/widgets/app_text.dart';

class ProfileVisitScreen extends StatefulWidget {
  const ProfileVisitScreen({super.key});
  @override
  State<ProfileVisitScreen> createState() => _ProfileVisitScreenState();
}

class _ProfileVisitScreenState extends State<ProfileVisitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
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
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  child: Icon(
                    Icons.person,
                    size: 110,
                    color: Colors.purple.shade300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            AppText(
              text: user.fullName,
              textFontSize: 25,
              textFontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20),
            AppText(text: user.bio == null ? "" : user.bio!, textFontSize: 16),
          ],
        ),
      ),
    );
  }
}
