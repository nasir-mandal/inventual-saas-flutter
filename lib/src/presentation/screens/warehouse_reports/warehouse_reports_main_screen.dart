import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/reports/warehouse_report.dart';
import 'package:inventual/src/data/models/dropdown.dart';
import 'package:inventual/src/presentation/screens/warehouse_reports/warehouse-reports_sections/horizontal_warehouse_report_table_section.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading_two.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/utils/contstants.dart';

class WarehouseReportsMainScreen extends StatefulWidget {
  const WarehouseReportsMainScreen({super.key});

  @override
  State<WarehouseReportsMainScreen> createState() =>
      _WarehouseReportsMainScreenState();
}

class _WarehouseReportsMainScreenState
    extends State<WarehouseReportsMainScreen> {
  final WarehouseReportReportController warehouseReportReportController =
      WarehouseReportReportController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  RxList<Map<String, dynamic>> warehouseReportUpdate =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    warehouseReportReportController.fetchAllWarehouseReport().then((data) {
      setState(() {
        warehouseReportUpdate.value = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          key: _key,
          child: const CustomAppBar(navigateName: "Warehouse Report")),
      body: Container(
        color: ColorSchema.white,
        child: ListView(
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
                          controller:
                              warehouseReportReportController.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller:
                              warehouseReportReportController.toDate.value,
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
                      child: CustomDropdownField(
                          hintText: "Select Report",
                          dropdownItems: reportShortcutType
                              .map((item) => item["title"] as String)
                              .toList(),
                          onSelectedValueChanged: (value) {
                            warehouseReportReportController.reportValue.value =
                                value;
                            warehouseReportReportController.reportID.value =
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
                        await warehouseReportReportController
                            .fetchAllWarehouseReport();
                    setState(() {
                      warehouseReportUpdate.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Warehouse Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => warehouseReportReportController.isLoading.value == true
                ? const TableLoadingTwo()
                : warehouseReportUpdate.isEmpty
                    ? const NotFound()
                    : SingleChildScrollView(
                        child: HorizontalWarehouseReportTableSection(
                        wareHouseList: warehouseReportUpdate,
                      ))),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
