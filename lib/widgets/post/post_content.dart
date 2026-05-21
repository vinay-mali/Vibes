import 'package:flutter/material.dart';
import 'package:vibes/models/post_model.dart';
import 'package:vibes/screens/photo_view_screen.dart';
import 'package:vibes/widgets/app_text.dart';

class PostContent extends StatelessWidget {
  final PostModel post;
  const PostContent({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 9, bottom: 3),
          child: AppText(text: post.content, textFontSize: 16),
        ),
        if (post.postPhotos != null && post.postPhotos!.isNotEmpty)
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: post.postPhotos!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return post.postPhotos != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 7,
                          bottom: 2,
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoViewScreen(heroTag: "post-image-${post.postID}-$index",
                                photo: post.postPhotos![index],
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(spreadRadius: 1, blurRadius: 3),
                              ],
                            ),

                            child: Hero(tag: "post-image-${post.postID}-$index",
                              child: Image.network(
                                post.postPhotos![index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null;
              },
            ),
          ),
      ],
    );
  }
}
