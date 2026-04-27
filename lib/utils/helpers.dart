import 'package:flutter/material.dart';

void scaffoldMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
String formatTime(DateTime time) {
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