import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/business_logic/purchase/purchase_controller.dart';
import 'package:inventual_saas/src/presentation/screens/purchase/purchase_sections/horizontal_purchase_table_section.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/table_loading_two.dart';
import 'package:inventual_saas/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseMainScreen extends StatefulWidget {
  const PurchaseMainScreen({super.key});
  @override
  State<PurchaseMainScreen> createState() => _PurchaseMainScreenState();
}

class _PurchaseMainScreenState extends State<PurchaseMainScreen> {
  final PurchaseController controller = PurchaseController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  RxList<Map<String, dynamic>> purchaseListUpdate =
      <Map<String, dynamic>>[].obs;
  late Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    controller.fetchAllPurchaseListData();
    _dependencyController.getAllWareHouse();
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
    // Check if userPermissions is available, if not, default to an empty map
    final permission = user['userPermissions'] ?? {};

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          surfaceTintColor: ColorSchema.white,
          backgroundColor: ColorSchema.white,
          centerTitle: true,
          title: Text(
            "Manage Purchase",
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
                    // Check if the user has view permission for purchases return
                    if (permission['view_permission_purchases_return'] ==
                        true) {
                      Get.toNamed(AppRoutes.purchaseReturn);
                    } else {
                      showDialog(
                          context: Get.context!,
                          builder: (context) => const NoPermissionDialog());
                    }
                  },
                  icon: SvgPicture.asset(
                    "assets/icons/icon_svg/purchase_return.svg",
                    width: 25,
                  )),
            )
          ]),
      body: Container(
        color: ColorSchema.white,
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Purchase List",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => controller.isLoading.value == true
                ? const TableLoadingTwo()
                : controller.purchasesList.isEmpty
                    ? const NotFound()
                    : SingleChildScrollView(
                        child: HorizontalPurchaseTableSection(
                        purchasesList: controller.purchasesList,
                      ))),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          buttonName: "Create Purchase",
          // Check if the user has add permission for purchases
          routeName: permission['add_permission_purchases'] == true
              ? AppRoutes.createPurchase
              : AppRoutes.noPermission),
    );
  }
}
