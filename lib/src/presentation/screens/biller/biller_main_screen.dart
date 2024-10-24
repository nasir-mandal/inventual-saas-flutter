import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/screens/biller/biller_sections/biller_list_section.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillerMainScreen extends StatefulWidget {
  const BillerMainScreen({super.key});

  @override
  State<BillerMainScreen> createState() => _BillerMainScreenState();
}

class _BillerMainScreenState extends State<BillerMainScreen> {
  final ProductDependencyController billerController =
      ProductDependencyController();

  late TextEditingController _searchController;
  String searchQuery = "";
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    billerController.getAllBillers();
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
    final permission = user['userPermissions'];
    List<Map<String, dynamic>> filteredBiller = billerController.billersList;
    if (searchQuery.isNotEmpty) {
      filteredBiller = filteredBiller.where((item) {
        return item["title"].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Biller"),
      ),
      body: Container(
        color: ColorSchema.white,
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
                  hintText: "Search Biller",
                  hintStyle: GoogleFonts.nunito(
                      textStyle: const TextStyle(color: ColorSchema.grey)),
                  suffixIcon: const Icon(Icons.search, color: ColorSchema.grey),
                  filled: true,
                  fillColor: ColorSchema.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: ColorSchema.grey.withOpacity(0.3), width: 1),
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
            Obx(() => billerController.getAllBillersLoading.value == true
                ? const UserCardLoading()
                : filteredBiller.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: BillerListSection(
                        billerList: filteredBiller,
                      ))),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          buttonName: "Create Biller",
          routeName: permission['add_permission_billers']
              ? AppRoutes.createBiller
              : AppRoutes.noPermission),
    );
  }
}
