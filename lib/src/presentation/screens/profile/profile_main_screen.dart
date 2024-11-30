import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/authentication.dart';
import 'package:inventual_saas/src/presentation/screens/profile/profile_section/edit_profile_section.dart';
import 'package:inventual_saas/src/presentation/screens/profile/profile_section/profile_info_row.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  late Map<String, dynamic> user = {};
  final UserController userController = Get.put(UserController());
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorSchema.profileColor1, ColorSchema.white],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: user['image'] != null &&
                                user['image'].isNotEmpty
                            ? NetworkImage(user['image']) as ImageProvider
                            : AssetImage(
                                    "assets/images/avatar/placeholder-user.png")
                                as ImageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            user['fullName'] ?? 'No User Name',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: ColorSchema.white),
                            ),
                          ),
                          Text(
                            user['role'] ?? 'No role Name',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                color: ColorSchema.white54,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account Info",
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ProfileInfoRow(
                              iconPath:
                                  "assets/icons/icon_svg/profile_name.svg",
                              label: "Full Name",
                              value: user['fullName'] ?? 'No Name',
                            ),
                            ProfileInfoRow(
                              iconPath:
                                  "assets/icons/icon_svg/profile_name.svg",
                              label: "Username",
                              value: user['username'] ?? 'No Name',
                            ),
                            ProfileInfoRow(
                              iconPath:
                                  "assets/icons/icon_svg/profile_phone.svg",
                              label: "Phone",
                              value: user['phone'] ?? 'No Phone',
                            ),
                            ProfileInfoRow(
                              iconPath:
                                  "assets/icons/icon_svg/profile_email.svg",
                              label: "Email",
                              value: user['email'] ?? 'No Email',
                            ),
                            ProfileInfoRow(
                              iconPath:
                                  "assets/icons/icon_svg/profile_gender.svg",
                              label: "Gender",
                              value: user['gender'] ?? 'No Gender',
                            ),
                            ProfileInfoRow(
                              iconPath:
                                  "assets/icons/icon_svg/profile_role.svg",
                              label: "Role",
                              value: user['role'] ?? 'No Role',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.38,
                        child: ElevatedButton(
                          onPressed: () {
                            buildShowModalBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: ColorSchema.primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_svg/edit_icon.svg",
                                color: ColorSchema.white70,
                                width: 15,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Edit Profile",
                                style: GoogleFonts.inter(
                                  color: ColorSchema.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 30,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.keyboard_arrow_left),
                  color: ColorSchema.white,
                  iconSize: 30,
                ))
          ],
        ),
      ),
    );
  }

  void buildShowModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: ColorSchema.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: const EditProfileSection(),
          );
        });
  }
}
