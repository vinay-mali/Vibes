import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? photoUrl;
  final double radius;

  const AppAvatar({super.key, required this.photoUrl, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
          ? NetworkImage(photoUrl!)
          : null,
      child: photoUrl == null || photoUrl!.isEmpty
          ? Icon(Icons.person, size: radius, color: Colors.deepPurple.shade300)
          : null,
    );
  }
}
