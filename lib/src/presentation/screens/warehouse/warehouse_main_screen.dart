import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/screens/warehouse/warehouse_sections/warehouse_list_section.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseMainScreen extends StatefulWidget {
  const WarehouseMainScreen({super.key});

  @override
  State<WarehouseMainScreen> createState() => _WarehouseMainScreenState();
}

class _WarehouseMainScreenState extends State<WarehouseMainScreen> {
  final ProductDependencyController _controller = ProductDependencyController();
  late TextEditingController _searchController;
  String searchQuery = "";
  late Map<String, dynamic> user = {};

  @override
  void initState() {
    _controller.getAllWareHouse();
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
    // Add null check for permissions
    final permission =
        user['userPermissions'] ?? {}; // Use empty map as fallback
    List<Map<String, dynamic>> filteredWareHouse = _controller.wareHouseList;

    if (searchQuery.isNotEmpty) {
      filteredWareHouse = filteredWareHouse.where((item) {
        return item["title"].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Warehouse"),
      ),
      body: Container(
        color: ColorSchema.white70,
        child: Column(
          children: [
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
                  hintText: "Search Warehouse",
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
            Obx(() => _controller.getAllWareHouseLoading.value == true
                ? const UserCardLoading()
                : filteredWareHouse.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: WarehouseListSection(
                        warehouseList: filteredWareHouse,
                      ))),
            Obx(() => _controller.getAllWareHouseLoading.value == true
                ? const SizedBox()
                : filteredWareHouse.isEmpty
                    ? const SizedBox()
                    : const SizedBox(
                        height: 80,
                      )),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        buttonName: "Add Warehouse",
        routeName: permission['add_permission_warehouses'] == true
            ? AppRoutes.addWarehouse
            : AppRoutes.noPermission, // Handle permission check
      ),
    );
  }
}
