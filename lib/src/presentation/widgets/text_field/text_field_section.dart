import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class TextFieldSection extends StatelessWidget {
  final String hint;
  final dynamic inputType;
  const TextFieldSection(
      {super.key, required this.hint, required this.inputType});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
            textStyle: const TextStyle(
          color: ColorSchema.grey,
          fontWeight: FontWeight.w500,
        )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: inputType,
    );
  }
}
