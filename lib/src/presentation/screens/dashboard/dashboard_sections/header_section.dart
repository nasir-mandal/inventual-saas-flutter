import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/authentication.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardHeaderSection extends StatefulWidget {
  final Function openDrawer;
  const DashboardHeaderSection({super.key, required this.openDrawer});
  @override
  State<DashboardHeaderSection> createState() => _DashboardHeaderSectionState();
}

class _DashboardHeaderSectionState extends State<DashboardHeaderSection> {
  final UserAuthenticationController userAuthenticationController =
      UserAuthenticationController();
  late Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSchema.white,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          left: 10,
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    widget.openDrawer();
                  },
                  child: ClipOval(
                    child: user['image'] != null && user['image'].isNotEmpty
                        ? FadeInImage.assetNetwork(
                            placeholder: "assets/images/gif/loading.gif",
                            image: user['image'])
                        : Image.asset(
                            "assets/images/avatar/placeholder-user.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${user['username'] ?? ""}",
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: ColorSchema.titleTextColor)),
                    ),
                    Text(
                      "${user['role'] ?? ""}",
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: ColorSchema.subTitleTextColor,
                              fontSize: 16)),
                    )
                  ],
                ),
              ],
            ),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                userAuthenticationController.logOut();
                Get.offNamed(AppRoutes.login);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorSchema.blue.withOpacity(0.05)),
                child: const Icon(
                  Icons.logout,
                  color: ColorSchema.primaryColor,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
