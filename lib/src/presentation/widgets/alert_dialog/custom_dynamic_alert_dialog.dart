import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CustomDynamicAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? okButtonName;
  final String? noButtonName;
  final String? yesButtonName;
  final void Function()? pressedNo;
  final void Function()? pressedYes;
  final void Function()? pressedOk;

  const CustomDynamicAlertDialog(
      {super.key,
      required this.title,
      required this.subTitle,
      this.okButtonName,
      this.noButtonName,
      this.yesButtonName,
      this.pressedNo,
      this.pressedYes,
      this.pressedOk});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0.5,
      backgroundColor: ColorSchema.white,
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      title: Text(title),
      content: Text(subTitle),
      actions: [
        if (noButtonName != null && noButtonName!.isNotEmpty)
          TextButton(
            onPressed: pressedNo,
            child: Text(
              noButtonName!,
              style: const TextStyle(color: ColorSchema.primaryColor),
            ),
          ),
        if (yesButtonName != null && yesButtonName!.isNotEmpty)
          TextButton(
            onPressed: pressedYes,
            child: Text(
              yesButtonName!,
              style: const TextStyle(color: ColorSchema.primaryColor),
            ),
          ),
        if (okButtonName != null && okButtonName!.isNotEmpty)
          TextButton(
            onPressed: pressedOk,
            child: Text(
              okButtonName!,
              style: const TextStyle(color: ColorSchema.primaryColor),
            ),
          ),
      ],
    );
  }
}
