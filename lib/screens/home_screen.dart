import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/screens/add_opinion_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:vibes/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vibes")),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: AppText(text: "Something went wrong."));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: AppText(text: "No Opinions yet. Be the first!"),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                final PostModel post = PostModel.fromMap(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>,
                );
                return PostCard(post: post);
              },
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey, thickness: 1);
              },
              itemCount: snapshot.data!.docs.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOpinionScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
          side: BorderSide(color: Colors.black, width: 2),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
