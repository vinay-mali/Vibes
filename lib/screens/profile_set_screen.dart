import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibes/models/user_model.dart';

import 'package:vibes/providers/user_provider.dart';
import 'package:vibes/screens/home_screen.dart';

import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';

class ProfileSetScreen extends StatefulWidget {
  final String mode;

  const ProfileSetScreen({super.key, required this.mode});

  @override
  State<ProfileSetScreen> createState() => _ProfileSetScreenState();
}

class _ProfileSetScreenState extends State<ProfileSetScreen> {
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController bioCtrl = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.mode == 'edit') {
      final currentUser = context.read<UserProvider>().getCurrentUser();

      context.read<UserProvider>().getUserByID(currentUser!.uid).then((_) {
        final userModel = context.read<UserProvider>().userModel;
        if (userModel != null && mounted) {
          setState(() {
            fullNameCtrl.text = userModel.fullName;
            usernameCtrl.text = userModel.username;
            bioCtrl.text = userModel.bio ?? "";
          });
        }
      });
    }
  }

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
    final currentUser = context.read<UserProvider>().getCurrentUser();
    if (currentUser == null) {
      scaffoldMessage(context, "User not found");
      return;
    }
    final bool usernameExists = await context
        .read<UserProvider>()
        .isUsernameTaken(usernameCtrl.text.trim().toLowerCase());
    if (usernameExists &&
        usernameCtrl.text.trim().toLowerCase() !=
            context.read<UserProvider>().userModel!.username) {
      scaffoldMessage(context, "Username already exists");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final UserModel userModel = UserModel(
        uid: currentUser.uid,
        username: usernameCtrl.text.trim().toLowerCase(),
        fullName: fullNameCtrl.text.trim(),
        bio: bioCtrl.text.trim().isEmpty ? "" : bioCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
      if (widget.mode == 'add') {
        await context.read<UserProvider>().createUser(
          currentUser.uid,
          userModel,
        );
      } else {
        await context.read<UserProvider>().updateUser(
          currentUser.uid,
          userModel,
        );
        await context.read<UserProvider>().getUserByID(currentUser.uid);
      }
      if (mounted) {
        if (widget.mode == 'add') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      scaffoldMessage(context, "Something went wrong. Please try again.");
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
        appBar: AppBar(
          title: Text(
            widget.mode == 'add' ? "Create your Profile" : "Edit Profile",
          ),
        ),
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
                                text: widget.mode == 'add' ? "Create" : "Save",
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
