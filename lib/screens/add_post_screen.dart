import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/utils/helpers.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController postCtrl = TextEditingController();
  bool _isLoading = false;
  final List<String> _hints = [
    "What's going on?",
    "Current Vibe...",
    "Share your thought...",
    "What's on your mind?",
    "Express yourself...",
  ];

  late final String _hint = _hints[Random().nextInt(_hints.length)];

  @override
  void dispose() {
    postCtrl.dispose();
    super.dispose();
  }

  Future<void> handlePost() async {
    if (postCtrl.text.trim().isEmpty) {
      scaffoldMessage(context, "Please write something.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final postDoc = FirebaseFirestore.instance.collection('posts').doc();
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final username = userDoc['username'];
      final fullName = userDoc['fullName'];
      final PostModel postModel = PostModel(
        postID: postDoc.id,
        content: postCtrl.text.trim(),
        createdAt: DateTime.now(),
        username: username,
        fullName: fullName,
      );
      await postDoc.set(postModel.toMap());
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      scaffoldMessage(context, "Failed to post! Try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Post"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: _isLoading ? null : handlePost,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    : Icon(Icons.send, color: Colors.deepPurple, size: 30),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: postCtrl,
                    maxLength: 300,
                    maxLines: null,
                    minLines: 7,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: _hint,
                      hintStyle: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
