import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CustomAppBar extends StatelessWidget {
  final String navigateName;

  const CustomAppBar({super.key, required this.navigateName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: ColorSchema.white,
      backgroundColor: ColorSchema.white,
      centerTitle: true,
      title: Text(
        navigateName,
        style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          )),
    );
  }
}
