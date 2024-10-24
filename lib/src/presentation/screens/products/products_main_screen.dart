import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/screens/products/products_sections/product-list_section.dart';
import 'package:inventual_saas/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/products_loaddings.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class ProductsMainScreen extends StatefulWidget {
  const ProductsMainScreen({Key? key}) : super(key: key);

  @override
  State<ProductsMainScreen> createState() => _ProductsMainScreenState();
}

class _ProductsMainScreenState extends State<ProductsMainScreen> {
  final ProductController _controller = Get.put(ProductController());

  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late TextEditingController _searchController;
  String searchQuery = "";
  late Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    _controller.getAllProducts();
    _searchController = TextEditingController();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
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
    final permission =
        user['userPermissions'] ?? {}; // Fallback to empty map if null
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      key: _key,
      endDrawer: DashboardDrawer(routeName: "Products", controller: controller),
      appBar: isSmallScreen
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorSchema.white,
              automaticallyImplyLeading: true,
              centerTitle: true,
              surfaceTintColor: ColorSchema.white,
              title: Text(
                "Product List",
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
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
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
                  ),
                )
              ],
            )
          : null,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: ProductListLoading());
        }

        List<Map<String, dynamic>> filteredProducts = _controller.productList;
        if (searchQuery.isNotEmpty) {
          filteredProducts = filteredProducts.where((item) {
            return item["title"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();
        }

        return Container(
          color: ColorSchema.white70,
          child: RefreshIndicator(
            onRefresh: () async {
              _controller.getAllProducts();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
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
                      hintText: "Search Product",
                      hintStyle: GoogleFonts.nunito(
                        textStyle: const TextStyle(color: ColorSchema.grey),
                      ),
                      suffixIcon:
                          const Icon(Icons.search, color: ColorSchema.grey),
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                filteredProducts.isEmpty
                    ? const NotFound()
                    : ProductListSection(
                        isSmallScreen: isSmallScreen,
                        productList: filteredProducts,
                      ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: CustomFloatingActionButton(
        buttonName: "Add Product",
        routeName: permission['add_permission_products'] == true
            ? AppRoutes.addProduct
            : AppRoutes.noPermission, // Handle permission check
      ),
    );
  }
}
