import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/business_logic/reports/sells_report_controller.dart';
import 'package:inventual_saas/src/data/models/dropdown.dart';
import 'package:inventual_saas/src/presentation/screens/sales/new_sales/new_sales_main_screen.dart';
import 'package:inventual_saas/src/presentation/screens/sales/salesSections/horizontal_sales_table_section.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/table_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class SalesMainScreen extends StatefulWidget {
  const SalesMainScreen({super.key});
  @override
  State<SalesMainScreen> createState() => _SalesMainScreenState();
}

class _SalesMainScreenState extends State<SalesMainScreen> {
  final SalesListController salesListController = SalesListController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  RxList<Map<String, dynamic>> salesListUpdate = <Map<String, dynamic>>[].obs;
  late Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
    salesListController.fetchAllSellsReport().then((data) {
      setState(() {
        salesListUpdate.value = data;
      });
    });
    _dependencyController.getAllWareHouse();
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
    return Scaffold(
      key: _key,
      endDrawer: Drawer(
        child: DashboardDrawer(routeName: "Trading", controller: controller),
      ),
      appBar: isSmallScreen
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorSchema.white70,
              automaticallyImplyLeading: true,
              centerTitle: true,
              surfaceTintColor: ColorSchema.white,
              title: Text(
                "Sales",
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
        color: ColorSchema.white,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "From Date",
                          hintText: "MM/DD/YYYY",
                          controller: salesListController.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: salesListController.toDate.value,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => CustomDropdownField(
                        hintText: "Select Warehouse",
                        dropdownItems: _dependencyController.wareHouseList
                            .map((item) => item["title"] as String)
                            .toList(),
                        onSelectedValueChanged: (value) {
                          salesListController.wareHouseValue.value = value;
                          salesListController.wareHouseID.value =
                              _dependencyController.wareHouseList.firstWhere(
                                  (item) => item["title"] == value)["id"];
                        })),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomDropdownField(
                          hintText: "Select Report",
                          dropdownItems: reportShortcutType
                              .map((item) => item["title"] as String)
                              .toList(),
                          onSelectedValueChanged: (value) {
                            salesListController.reportValue.value = value;
                            salesListController.reportID.value =
                                reportShortcutType.firstWhere(
                                    (item) => item["title"] == value)["id"];
                          }))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomElevatedButton(
                  buttonName: "Generate Report",
                  onPressed: () async {
                    List<Map<String, dynamic>> data =
                        await salesListController.fetchAllSellsReport();
                    setState(() {
                      salesListUpdate.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Sales Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => salesListController.isLoading.value == true
                ? const TableLoading()
                : salesListUpdate.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: SingleChildScrollView(
                            child: HorizontalSalesTableSection(
                          sellsReport: salesListUpdate,
                        )),
                      )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            if (permission['add_permission_sales']) {
              Get.to(const NewSalesMainScreen());
            } else {
              showDialog(
                  context: Get.context!,
                  builder: (context) => const NoPermissionDialog());
            }
          },
          label: Text(
            "Create Sales",
            style: GoogleFonts.raleway(
                color: ColorSchema.white70,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          icon: const Icon(
            Icons.add_circle_outline_sharp,
            color: ColorSchema.white70,
            size: 24,
          ),
          backgroundColor: ColorSchema.primaryColor,
        ),
      ),
    );
  }
}
