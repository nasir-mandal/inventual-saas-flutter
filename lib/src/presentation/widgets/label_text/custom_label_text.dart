import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CustomLabelText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final bool isRequired;

  const CustomLabelText({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.color = ColorSchema.lightBlack,
    this.fontWeight = FontWeight.w500,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize.sp,
          color: color,
          fontWeight: fontWeight,
        ),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: ColorSchema.danger,
                    fontSize: fontSize.sp,
                    fontWeight: fontWeight,
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
