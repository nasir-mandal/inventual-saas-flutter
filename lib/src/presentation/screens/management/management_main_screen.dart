import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/people/user/user_controller.dart';
import 'package:inventual_saas/src/presentation/screens/management/management_sections/user_list_card_section.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagementMainScreen extends StatefulWidget {
  const ManagementMainScreen({super.key});

  @override
  State<ManagementMainScreen> createState() => _ManagementMainScreenState();
}

class _ManagementMainScreenState extends State<ManagementMainScreen> {
  final UserListController userListController = UserListController();
  late TextEditingController _searchController;
  late Map<String, dynamic> user = {};
  String searchQuery = "";

  @override
  void initState() {
    userListController.fetchAllUsers();
    _searchController = TextEditingController();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    // Check if user and userPermissions are available
    final permission =
        user['userPermissions'] ?? {}; // Default to empty map if null
    List<Map<String, dynamic>> filteredUsers = userListController.usersList;

    if (searchQuery.isNotEmpty) {
      filteredUsers = filteredUsers.where((item) {
        return item["name"].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: ColorSchema.white,
        backgroundColor: ColorSchema.white,
        centerTitle: true,
        title: Text(
          "User List",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.userRole);
                },
                icon: SvgPicture.asset(
                  "assets/icons/icon_svg/user_role.svg",
                  width: 25,
                )),
          )
        ],
      ),
      body: Container(
        color: ColorSchema.white70,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search User",
                  hintStyle: GoogleFonts.nunito(
                      textStyle: const TextStyle(color: ColorSchema.grey)),
                  suffixIcon: const Icon(Icons.search, color: ColorSchema.grey),
                  filled: true,
                  fillColor: ColorSchema.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: ColorSchema.grey.withOpacity(0.2), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: ColorSchema.primaryColor, width: 1),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => userListController.isLoading.value == true
                ? const UserCardLoading()
                : filteredUsers.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: UserListCardSection(usersList: filteredUsers))),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          buttonName: "Add User",
          routeName: permission['add_permission_users'] == true
              ? AppRoutes.addUser
              : AppRoutes.noPermission),
    );
  }
}
