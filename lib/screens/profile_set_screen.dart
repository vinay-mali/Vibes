import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibes/models/user_model.dart';
import 'package:vibes/screens/home_screen.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';

class ProfileSetScreen extends StatefulWidget {
  const ProfileSetScreen({super.key});

  @override
  State<ProfileSetScreen> createState() => _ProfileSetScreenState();
}

class _ProfileSetScreenState extends State<ProfileSetScreen> {
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController bioCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    fullNameCtrl.dispose();
    usernameCtrl.dispose();
    bioCtrl.dispose();
    super.dispose();
  }

  Future<void> handleProfileCreate() async {
    if (usernameCtrl.text.trim().isEmpty || fullNameCtrl.text.trim().isEmpty) {
      scaffoldMessage(context, "Please enter the required details");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: usernameCtrl.text.trim().toLowerCase())
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        scaffoldMessage(context, "Username already taken. Try another");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;
      UserModel userModel = UserModel(
        uid: user!.uid,
        username: usernameCtrl.text.trim().toLowerCase(),
        fullName: fullNameCtrl.text.trim(),
        bio: bioCtrl.text.trim().isEmpty ? null : bioCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      scaffoldMessage(context, "Something went wrong. Please try again");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Create your Profile")),
        body: SingleChildScrollView(
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                    ),
                    child: TextField(
                      style: GoogleFonts.poppins(),
                      controller: fullNameCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Full name",
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                    ),
                    child: TextField(
                      style: GoogleFonts.poppins(),
                      controller: usernameCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Username",
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                    ),
                    child: TextField(
                      maxLines: 3,
                      minLines: 3,
                      style: GoogleFonts.poppins(),
                      controller: bioCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Bio",
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : handleProfileCreate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            35,
                            76,
                            148,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : AppText(
                                text: "Create",
                                textColor: Colors.white,
                                textFontSize: 18,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
