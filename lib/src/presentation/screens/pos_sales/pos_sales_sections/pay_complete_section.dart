import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/presentation/screens/reports/report_main_screen.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/utils/contstants.dart';

class PayCompleteSection extends StatefulWidget {
  const PayCompleteSection({Key? key}) : super(key: key);

  @override
  State<PayCompleteSection> createState() => _PayCompleteSectionState();
}

class _PayCompleteSectionState extends State<PayCompleteSection> {
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchema.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Purchase Complete",
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorSchema.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (_, double value, __) {
                  return Transform.scale(
                    scale: value,
                    child: Image.asset(
                      "assets/icons/icon_image/tick_mark_icon.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                "Thank You!",
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: ColorSchema.grey.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Order Number",
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: ColorSchema.black,
                      ),
                    ),
                  ),
                  Text(
                    "Order ID #251475781",
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: ColorSchema.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                  buttonName: "Back To Home",
                  onPressed: () {
                    Get.off(const ReportMainScreen());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
