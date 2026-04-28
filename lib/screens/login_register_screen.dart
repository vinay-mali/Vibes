import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibes/services/auth_service.dart';
import 'package:vibes/screens/home_screen.dart';
import 'package:vibes/screens/profile_set_screen.dart';

import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';

class LoginRegisterScreen extends StatefulWidget {
  final String mode;
  const LoginRegisterScreen({super.key, required this.mode});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool showPassword = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> handleSignup() async {
    String email = emailCtrl.text.trim();
    String password = passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      scaffoldMessage(context, "Please fill the required details.");
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = await _authService.registerUser(email, password);
      if (user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileSetScreen(mode: 'add'),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      scaffoldMessage(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> handleLogin() async {
    String email = emailCtrl.text.trim();
    String password = passwordCtrl.text.trim();
    if (email.isEmpty || password.isEmpty) {
      scaffoldMessage(context, "Please enter required details.");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      User? user = await _authService.loginUser(email, password);
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                doc.exists ? HomeScreen() : ProfileSetScreen(mode: 'add'),
          ),
        );
      }
    } catch (e) {
      if (mounted) scaffoldMessage(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.mode == 'login' ? "Log in" : "Sign up"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAA88E8), Color(0xFF88C8F0)],
              ),
            ),
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 15,
                        right: 15,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: const Color.fromARGB(255, 77, 40, 142),
                        style: GoogleFonts.poppins(color: Colors.black),
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                          labelStyle: GoogleFonts.poppins(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 15,
                        right: 15,
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        obscureText: showPassword,
                        style: GoogleFonts.poppins(),
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          prefixIcon: Icon(Icons.password),
                          labelText: "Password",
                          labelStyle: GoogleFonts.poppins(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : widget.mode == 'login'
                              ? handleLogin
                              : handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              35,
                              87,
                              178,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: !_isLoading
                              ? AppText(
                                  text: widget.mode == 'login'
                                      ? "Log in"
                                      : "Sign up",
                                  textColor: Colors.white,
                                  textFontSize: 18,
                                )
                              : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (widget.mode == 'login') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginRegisterScreen(mode: 'signup'),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginRegisterScreen(mode: 'login'),
                            ),
                          );
                        }
                      },
                      child: AppText(
                        text: widget.mode == 'login'
                            ? "Don't have an account? Create now."
                            : "Already have an account? Log in.",
                        textColor: const Color.fromARGB(255, 54, 25, 103),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
