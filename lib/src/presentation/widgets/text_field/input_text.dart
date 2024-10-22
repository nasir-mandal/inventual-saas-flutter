import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

Widget buildInputTextField(String hint, keyboardType,
    TextEditingController inputValue, String message) {
  return TextFormField(
    controller: inputValue,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fillColor: ColorSchema.white,
      filled: true,
      hintText: hint,
      hintStyle: GoogleFonts.nunito(
        textStyle: const TextStyle(
          color: ColorSchema.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorSchema.danger),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ColorSchema.borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorSchema.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    keyboardType: keyboardType,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    },
  );
}

Widget buildOptionalInputTextField(
    String hint, TextInputType keyboardType, TextEditingController inputValue) {
  return TextFormField(
    controller: inputValue,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fillColor: ColorSchema.white,
      filled: true,
      hintText: hint,
      hintStyle: GoogleFonts.nunito(
        textStyle: const TextStyle(
          color: ColorSchema.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ColorSchema.borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorSchema.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    keyboardType: keyboardType,
  );
}

Widget buildOptionalWithDefaultInputTextField(
    String hint, TextInputType keyboardType, TextEditingController inputValue,
    {String defaultValue = ''}) {
  inputValue.text = defaultValue;

  return TextFormField(
    controller: inputValue,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      fillColor: ColorSchema.white,
      filled: true,
      hintText: hint,
      hintStyle: GoogleFonts.nunito(
        textStyle: const TextStyle(
          color: ColorSchema.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ColorSchema.borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorSchema.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    keyboardType: keyboardType,
  );
}
