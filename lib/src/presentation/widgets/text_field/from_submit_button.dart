import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

buildFromSubmitButton(
    {required void Function()? checkValidation, required String buttonName}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: ColorSchema.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    onPressed: checkValidation,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40),
      child: Text(
        buttonName,
        style: GoogleFonts.raleway(
            color: ColorSchema.white,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    ),
  );
}
