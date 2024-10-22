import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/reports/discount_report.dart';
import 'package:inventual/src/presentation/screens/discount_reports/discount_report_sections/horizontal_discount_report_table_section.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:sidebarx/sidebarx.dart';

class DiscountReportMainScreen extends StatefulWidget {
  const DiscountReportMainScreen({Key? key}) : super(key: key);

  @override
  State<DiscountReportMainScreen> createState() =>
      _DiscountReportMainScreenState();
}

class _DiscountReportMainScreenState extends State<DiscountReportMainScreen> {
  final DiscountReportReportController controllerDiscount =
      DiscountReportReportController();

  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  RxList<Map<String, dynamic>> reportUpdateList = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    controllerDiscount.fetchAllDiscountReport().then((data) {
      setState(() {
        reportUpdateList.value = data;
      });
    });
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
                "Discount Report",
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
                          controller: controllerDiscount.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: controllerDiscount.toDate.value,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomElevatedButton(
                  buttonName: "Generate Report",
                  showToast: () async {
                    List<Map<String, dynamic>> data =
                        await controllerDiscount.fetchAllDiscountReport();
                    setState(() {
                      reportUpdateList.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Discount Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => controllerDiscount.isLoading.value == true
                ? const TableLoading()
                : reportUpdateList.isEmpty
                    ? const NotFound()
                    : Expanded(
                        child: SingleChildScrollView(
                            child: HorizontalDiscountReportTableSection(
                          report: reportUpdateList,
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
