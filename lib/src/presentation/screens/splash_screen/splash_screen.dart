import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/settings_controller.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SettingsController settingsController = SettingsController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    settingsController.loadSettings();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("user");
    final String? supplierKey = prefs.getString("supplier_key");
    if (user != null) {
      final decodeUser = json.decode(user);
      final token = decodeUser["token"];
      if (token != null) {
        Timer(const Duration(seconds: 5), () {
          Get.toNamed(AppRoutes.dashboard);
        });
      } else {}
    } else {
      if (supplierKey != null && supplierKey.isNotEmpty) {
        Timer(const Duration(seconds: 5), () {
          Navigator.pushNamed(context, AppRoutes.login);
        });
      } else {
        Timer(const Duration(seconds: 5), () {
          Navigator.pushNamed(context, AppRoutes.onboarding);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorSchema.primaryColor,
              ColorSchema.secondaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ScaleTransition(
                      scale: _animation,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ColorSchema.black.withOpacity(0.25),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: ColorSchema.white,
                          radius: MediaQuery.of(context).size.width * 0.2,
                          child: Padding(
                            padding: REdgeInsets.all(15),
                            child: Image.asset(
                              "assets/images/logo/login-logo.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _animation,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Powered By BDevs",
                          style: GoogleFonts.nunito(
                            color: ColorSchema.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "V 1.0.0",
                          style: GoogleFonts.nunito(
                            color: ColorSchema.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
