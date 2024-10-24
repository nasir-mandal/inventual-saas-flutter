import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class SuccessToast {
  static void showSuccessToast(
      BuildContext context, String toastTitle, String toastText) {
    CherryToast.success(
      borderRadius: 8,
      animationType: AnimationType.fromTop,
      action: Text(
        toastText,
        style: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.black,
          ),
        ),
      ),
      title: Text(
        toastTitle,
        style: GoogleFonts.raleway(
          textStyle: const TextStyle(
            color: ColorSchema.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).show(context);
  }
}
