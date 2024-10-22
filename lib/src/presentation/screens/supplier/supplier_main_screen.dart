import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/presentation/screens/supplier/supplier_sections/supplier_list_section.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierMainScreen extends StatefulWidget {
  const SupplierMainScreen({super.key});

  @override
  State<SupplierMainScreen> createState() => _SupplierMainScreenState();
}

class _SupplierMainScreenState extends State<SupplierMainScreen> {
  final ProductDependencyController supplierController =
      ProductDependencyController();
  late TextEditingController _searchController;
  String searchQuery = "";
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    supplierController.getAllSuppliers();
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
    List<Map<String, dynamic>> filteredSupplier =
        supplierController.suppliersList;
    if (searchQuery.isNotEmpty) {
      filteredSupplier = filteredSupplier.where((item) {
        return item["title"].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Supplier"),
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
                  hintText: "Search Supplier",
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
            Obx(() => supplierController.getAllSuppliersLoading.value == true
                ? const UserCardLoading()
                : filteredSupplier.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: SupplierListSection(
                        suppliersList: filteredSupplier,
                      ))),
            Obx(() => supplierController.getAllSuppliersLoading.value == true
                ? const SizedBox()
                : const SizedBox(
                    height: 80,
                  )),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          buttonName: "Create Supplier",
          routeName: permission['add_permission_suppliers']
              ? AppRoutes.createSupplier
              : AppRoutes.noPermission),
    );
  }
}
