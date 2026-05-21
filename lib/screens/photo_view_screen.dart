import 'package:flutter/material.dart';

class PhotoViewScreen extends StatefulWidget {
  final String photo;
  final String heroTag;
  const PhotoViewScreen({
    super.key,
    required this.photo,
    required this.heroTag,
  });
  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 30),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 4.0,
          child: Hero(
            tag: widget.heroTag,
            child: Image.network(widget.photo, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
