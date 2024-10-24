import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/business_logic/reports/supplier_report.dart';
import 'package:inventual_saas/src/presentation/screens/supplier_reports/supplier_reports_sections/horizontal_supplier_report_table_section.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/table_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:sidebarx/sidebarx.dart';

class SupplierReportsMainScreen extends StatefulWidget {
  const SupplierReportsMainScreen({Key? key}) : super(key: key);

  @override
  State<SupplierReportsMainScreen> createState() =>
      _SupplierReportsMainScreenState();
}

class _SupplierReportsMainScreenState extends State<SupplierReportsMainScreen> {
  final SupplierReportReportController supplierController =
      SupplierReportReportController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  RxList<Map<String, dynamic>> supplierListUpdate =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    supplierController.fetchAllSupplierReport().then((data) {
      setState(() {
        supplierListUpdate.value = data;
      });
    });
    _dependencyController.getAllWareHouse();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      key: _key,
      endDrawer: DashboardDrawer(routeName: "Reports", controller: controller),
      appBar: isSmallScreen
          ? AppBar(
              elevation: 0,
              backgroundColor: ColorSchema.white,
              automaticallyImplyLeading: true,
              centerTitle: true,
              surfaceTintColor: ColorSchema.white,
              title: Text(
                "Supplier Report",
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
                      _key.currentState!.openEndDrawer();
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
                          controller: supplierController.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: supplierController.toDate.value,
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
                          supplierController.wareHouseValue.value = value;
                          supplierController.wareHouseID.value =
                              _dependencyController.wareHouseList.firstWhere(
                                  (item) => item["title"] == value)["id"];
                        })),
                  ),
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
                        await supplierController.fetchAllSupplierReport();
                    setState(() {
                      supplierListUpdate.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Supplier Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => supplierController.isLoading.value == true
                ? const TableLoading()
                : supplierListUpdate.isEmpty
                    ? const NotFound()
                    : Expanded(
                        child: SingleChildScrollView(
                            child: HorizontalSupplierReportTableSection(
                          suppliersList: supplierListUpdate,
                        )),
                      )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
