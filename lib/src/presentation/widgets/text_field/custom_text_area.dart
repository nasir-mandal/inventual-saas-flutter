import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final dynamic controllerName;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final double? hintTextSize;
  final int? masLine;

  const CustomTextArea(
      {super.key,
      required this.hintText,
      this.controllerName,
      this.onChanged,
      this.validator,
      this.hintTextSize = 14,
      this.masLine = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 12.sp),
      cursorColor: ColorSchema.grey.withOpacity(0.2),
      controller: controllerName,
      onChanged: onChanged,
      maxLines: masLine,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 12.w),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(
            textStyle: TextStyle(
          fontSize: hintTextSize,
          color: ColorSchema.grey,
          fontWeight: FontWeight.w500,
        )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide:
              BorderSide(color: ColorSchema.grey.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorSchema.grey.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.circular(4.r),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: TextInputType.text,
    );
  }
}
