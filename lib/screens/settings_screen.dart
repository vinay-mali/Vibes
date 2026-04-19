import 'package:flutter/material.dart';
import 'package:vibes/services/auth_service.dart';
import 'package:vibes/utils/helpers.dart';
import 'package:vibes/widgets/app_text.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  Widget _tiles(
    String text,
    Color color,
    FontWeight fontWeight,
    double fontSize,
    VoidCallback onTap,
  ) {
    return Card(
      shadowColor: Colors.black,

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: onTap,
          title: AppText(
            text: text,
            textColor: color,
            textFontWeight: fontWeight,
            textFontSize: fontSize,
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 235, 211, 239),
              const Color.fromARGB(255, 210, 190, 243),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _tiles("Log out", Colors.red, FontWeight.w500, 18, () {
                showDialog(
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          title: AppText(
                            text: "Are you sure you want to log out?",
                            textFontSize: 16,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: AppText(text: "Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      try {
                                        setDialogState(() {
                                          _isLoading = true;
                                        });
                                        await _authService.signOut();
                                        Restart.restartApp();
                                      } catch (e) {
                                        scaffoldMessage(
                                          context,
                                          "Something went wrong",
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : AppText(
                                      text: "Log out",
                                      textColor: Colors.white,
                                      textFontSize: 15,
                                    ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
