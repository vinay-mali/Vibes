import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibes/screens/login_register_screen.dart';
import 'package:vibes/screens/main_screen.dart';
import 'package:vibes/screens/profile_set_screen.dart';
import 'package:vibes/screens/splash_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (!snapshot.hasData) {
          return LoginRegisterScreen(mode: 'login');
        }
        return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData && userSnapshot.data!.exists) {
              return MainScreen();
            }
            return ProfileSetScreen(mode: 'add');
          },
        );
      },
    );
  }
}
