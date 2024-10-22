import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;

  const CustomSearchField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(
            textStyle: const TextStyle(color: ColorSchema.grey)),
        suffixIcon: const Icon(Icons.search, color: ColorSchema.grey),
        filled: true,
        fillColor: ColorSchema.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
