import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/reports/stock_report.dart';
import 'package:inventual/src/presentation/screens/stock_reports/stock_reports_sections/horizontal_stock_report_table_section.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:sidebarx/sidebarx.dart';

class StockReportsMainScreen extends StatefulWidget {
  const StockReportsMainScreen({Key? key}) : super(key: key);

  @override
  State<StockReportsMainScreen> createState() => _StockReportsMainScreenState();
}

class _StockReportsMainScreenState extends State<StockReportsMainScreen> {
  final StockReportReportController stockController =
      StockReportReportController();

  final controller = SidebarXController(selectedIndex: 1, extended: true);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  RxList<Map<String, dynamic>> stockReportUpdate = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    stockController.fetchAllStockReport().then((data) {
      setState(() {
        stockReportUpdate.value = data;
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
                "Stock Report",
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
                          controller: stockController.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: stockController.toDate.value,
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
                        await stockController.fetchAllStockReport();
                    setState(() {
                      stockReportUpdate.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Stock Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => stockController.isLoading.value == true
                ? const TableLoading()
                : stockReportUpdate.isEmpty
                    ? const NotFound()
                    : Expanded(
                        child: SingleChildScrollView(
                            child: HorizontalStockReportTableSection(
                          report: stockReportUpdate,
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
