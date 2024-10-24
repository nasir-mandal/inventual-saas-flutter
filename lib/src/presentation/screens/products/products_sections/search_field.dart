import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String> onTextChanged;

  const SearchField({super.key, required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: TextField(
        onChanged: onTextChanged,
        decoration: InputDecoration(
          hintText: "Search Product",
          hintStyle: GoogleFonts.nunito(
              textStyle: const TextStyle(color: ColorSchema.grey)),
          suffixIcon: const Icon(Icons.search, color: ColorSchema.grey),
          filled: true,
          fillColor: ColorSchema.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorSchema.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: ColorSchema.primaryColor, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
