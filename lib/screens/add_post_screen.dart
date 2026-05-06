import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/providers/post_provider.dart';
import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/utils/helpers.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController postCtrl = TextEditingController();
  bool isLoading = false;
  List<File> _pickedImages = [];

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
      isLoading = true;
    });

    try {
      final userModel = context.read<UserProvider>().currentuserModel;
      if (userModel == null) {
        scaffoldMessage(context, "User not found");
        return;
      }

      List<String> postPhotoUrl = [];

      if (_pickedImages.isNotEmpty) {
        final result = await context.read<PostProvider>().uploadPostPhotos(
          _pickedImages,
        );
        postPhotoUrl = result.map((e) => e['url'] as String).toList();
      }

      final doc = FirebaseFirestore.instance.collection('posts').doc();

      final PostModel postModel = PostModel(
        postID: doc.id,
        content: postCtrl.text.trim(),
        createdAt: DateTime.now(),
        uid: userModel.uid,
        username: userModel.username,
        fullName: userModel.fullName,
        likedBy: [],
        likesCount: 0,
        commentsCount: 0,
        photoUrl: userModel.photoUrl,
        postPhotos: postPhotoUrl,
      );
      await context.read<PostProvider>().createPost(postModel);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      scaffoldMessage(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      final results = await Future.wait(
        picked.map(
          (xFile) => FlutterImageCompress.compressAndGetFile(
            xFile.path,
            '${xFile.path}_compressed.jpg',
            quality: 40,
            minWidth: 800,
            minHeight: 800,
          ),
        ),
      );
      setState(() {
        _pickedImages.addAll(
          results.whereType<XFile>().map((f) => File(f.path)),
        );
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
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
                onPressed: isLoading ? null : handlePost,
                icon: isLoading
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: _pickImages,
                      icon: Icon(
                        Icons.photo,
                        size: 30,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: _pickedImages.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 110,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(blurRadius: 5, spreadRadius: 1),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _pickedImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
