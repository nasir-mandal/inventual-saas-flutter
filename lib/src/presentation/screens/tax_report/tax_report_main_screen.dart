import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/reports/tax_report.dart';
import 'package:inventual/src/data/models/dropdown.dart';
import 'package:inventual/src/presentation/screens/tax_report/tax_report_sections/horizontal_tax_report_table_section.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading_two.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/utils/contstants.dart';

class TaxReportMainScreen extends StatefulWidget {
  const TaxReportMainScreen({super.key});

  @override
  State<TaxReportMainScreen> createState() => _TaxReportMainScreenState();
}

class _TaxReportMainScreenState extends State<TaxReportMainScreen> {
  final TaxReportReportController reportController =
      TaxReportReportController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  RxList<Map<String, dynamic>> reportList = <Map<String, dynamic>>[].obs;
  @override
  void initState() {
    super.initState();
    reportController.fetchAllTaxReport().then((data) {
      setState(() {
        reportList.value = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          key: _key,
          child: const CustomAppBar(navigateName: "Tax Report")),
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
                          controller: reportController.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: reportController.toDate.value,
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
                            reportController.reportValue.value = value;
                            reportController.reportID.value =
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
                        await reportController.fetchAllTaxReport();
                    setState(() {
                      reportList.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Tax Reports",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => reportController.isLoading.value == true
                ? const TableLoadingTwo()
                : reportList.isEmpty
                    ? const NotFound()
                    : SingleChildScrollView(
                        child: HorizontalTaxReportTableSection(
                        listData: reportList,
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
