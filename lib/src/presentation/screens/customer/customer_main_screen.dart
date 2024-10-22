import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/people/customer/customer_controller.dart';
import 'package:inventual/src/presentation/screens/customer/customer_sections/customer_list_section.dart';
import 'package:inventual/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final CustomerController customerController = CustomerController();

  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late TextEditingController _searchController;
  late Map<String, dynamic> user = {};
  String searchQuery = "";
  @override
  void initState() {
    customerController.fetchAllCustomers();
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    List<Map<String, dynamic>> filteredCustomer =
        customerController.customerList;
    if (searchQuery.isNotEmpty) {
      filteredCustomer = filteredCustomer.where((item) {
        return item["name"].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }
    return Scaffold(
      key: _key,
      endDrawer: DashboardDrawer(routeName: "Customer", controller: controller),
      appBar: isSmallScreen
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorSchema.white,
              automaticallyImplyLeading: true,
              centerTitle: true,
              surfaceTintColor: ColorSchema.white,
              title: Text(
                "Customer",
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (!Platform.isAndroid && !Platform.isIOS) {
                      controller.setExtended(true);
                    }
                    if (_key.currentState != null) {
                      _key.currentState?.openEndDrawer();
                    }
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                )
              ],
            )
          : null,
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
                  hintText: "Search Customer",
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
            Obx(() => customerController.isLoading.value == true
                ? const UserCardLoading()
                : filteredCustomer.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: CustomerListSection(
                        customerList: filteredCustomer,
                      ))),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          buttonName: "Create Customer",
          routeName: permission['add_permission_customers']
              ? AppRoutes.addCustomer
              : AppRoutes.noPermission),
    );
  }
}
