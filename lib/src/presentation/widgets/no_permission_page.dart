import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class NoPermissionPage extends StatelessWidget {
  const NoPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You don't have permission to access",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600, color: ColorSchema.lightBlack),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSchema.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Text(
                  "Back",
                  style: GoogleFonts.raleway(
                      color: ColorSchema.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
