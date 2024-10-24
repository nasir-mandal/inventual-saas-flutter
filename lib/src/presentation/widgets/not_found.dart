import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class NotFound extends StatelessWidget {
  final String? message;
  const NotFound({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? "No Found",
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600, color: ColorSchema.lightBlack),
      ),
    );
  }
}
