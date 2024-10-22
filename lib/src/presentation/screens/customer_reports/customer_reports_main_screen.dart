import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/business_logic/reports/customer_report.dart';
import 'package:inventual/src/presentation/screens/customer_reports/customer_reoprts_sections/horizontal_customer_report_table_Section.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomerReportsMainScreen extends StatefulWidget {
  const CustomerReportsMainScreen({Key? key}) : super(key: key);

  @override
  State<CustomerReportsMainScreen> createState() =>
      _CustomerReportsMainScreenState();
}

class _CustomerReportsMainScreenState extends State<CustomerReportsMainScreen> {
  final CustomerReportReportController customerController =
      CustomerReportReportController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  RxList<Map<String, dynamic>> customerListUpdate =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    customerController.fetchAllCustomersReport().then((data) {
      setState(() {
        customerListUpdate.value = data;
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
                "Customer Report",
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
                          controller: customerController.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: customerController.toDate.value,
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
                          customerController.wareHouseValue.value = value;
                          customerController.wareHouseID.value =
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
                        await customerController.fetchAllCustomersReport();
                    setState(() {
                      customerListUpdate.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Customer Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => customerController.isLoading.value == true
                ? const TableLoading()
                : customerListUpdate.isEmpty
                    ? const NotFound()
                    : Expanded(
                        child: SingleChildScrollView(
                            child: HorizontalCustomerReportTableSection(
                          customerList: customerListUpdate,
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
