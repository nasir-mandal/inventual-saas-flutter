import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.subTitle,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0.5,
      backgroundColor: ColorSchema.white,
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(title),
      content: Text(subTitle),
      actions: [
        TextButton(
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.clear();
            Get.offAllNamed(AppRoutes.login);
          },
          child: const Text(
            "Ok",
            style: TextStyle(color: ColorSchema.primaryColor),
          ),
        )
      ],
    );
  }
}
