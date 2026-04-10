import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  const AppText({super.key, required this.text,this.textFontSize,this.textFontWeight, this.textColor});

  final String text;
  final double? textFontSize;
  final FontWeight? textFontWeight;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
      fontSize: textFontSize,
      fontWeight: textFontWeight,
      color: textColor,
    ));
  }
}
