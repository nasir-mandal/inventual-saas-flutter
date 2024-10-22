
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:inventual/src/utils/contstants.dart';

class ToastHelper {
  static void showToast(
      BuildContext context, {
        required String message,
        Color? backgroundColor,
        Color? textColor,
        FontWeight? fontWeight,
        GFToastPosition? toastPosition,
      }) {
    GFToast.showToast(
      message,
      context,
      textStyle: TextStyle(
        color: textColor ?? ColorSchema.lightBlack,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
      toastPosition: toastPosition ?? GFToastPosition.BOTTOM,
      backgroundColor: backgroundColor ?? ColorSchema.light,
    );
  }
}
