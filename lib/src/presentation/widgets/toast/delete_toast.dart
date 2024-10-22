import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class DeleteToast {
  static void showDeleteToast(BuildContext context, String productName) {
    CherryToast.success(
      toastDuration: const Duration(seconds: 1),
      borderRadius: 8,
      iconWidget: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: ColorSchema.red.withOpacity(0.05),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            "assets/icons/icon_svg/delete_icon.svg",
            color: ColorSchema.red,
          ),
        ),
      ),
      animationType: AnimationType.fromTop,
      action: Text(
        "$productName Delete Complete",
        style: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.black,
          ),
        ),
      ),
      title: Text(
        "Delete Complete",
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
