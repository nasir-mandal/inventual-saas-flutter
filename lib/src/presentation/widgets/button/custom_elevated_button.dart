import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final double? buttonRadius;

  const CustomElevatedButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.buttonRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorSchema.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius!.r),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Text(
          buttonName,
          style: GoogleFonts.raleway(
            color: ColorSchema.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
