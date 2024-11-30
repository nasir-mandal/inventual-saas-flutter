import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class NoPermissionDialog extends StatelessWidget {
  const NoPermissionDialog({
    super.key,
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
      title: const Row(
        children: [
          Text("Denied access"),
        ],
      ),
      content: const Text("You don't have permission to access"),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
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
