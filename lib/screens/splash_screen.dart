import 'package:flutter/material.dart';
import 'package:vibes/widgets/app_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAA88E8), Color(0xFF88C8F0)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: "VIBES",
                textFontSize: 50,
                textFontWeight: FontWeight.bold,
              ),
              AppText(text: "Your world, your vibe. "),
            ],
          ),
        ),
      ),
    );
  }
}
