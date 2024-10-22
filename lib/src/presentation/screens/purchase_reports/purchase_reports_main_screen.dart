import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/business_logic/reports/purchase_report.dart';
import 'package:inventual/src/data/models/dropdown.dart';
import 'package:inventual/src/presentation/screens/purchase_reports/purchase_report_table.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/loadings/table_loading_two.dart';
import 'package:inventual/src/presentation/widgets/not_found.dart';
import 'package:inventual/src/utils/contstants.dart';

class PurchaseReportsMainScreen extends StatefulWidget {
  const PurchaseReportsMainScreen({super.key});
  @override
  State<PurchaseReportsMainScreen> createState() =>
      _PurchaseReportsMainScreenState();
}

class _PurchaseReportsMainScreenState extends State<PurchaseReportsMainScreen> {
  final PurchaseReportController controller = PurchaseReportController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  RxList<Map<String, dynamic>> purchaseListUpdate =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    controller.fetchAllPurchaseReport().then((data) {
      setState(() {
        purchaseListUpdate.value = data;
      });
    });
    _dependencyController.getAllWareHouse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            navigateName: "Purchase Report",
            key: _key,
          )),
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
                          controller: controller.fromDate.value,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "To Date",
                          hintText: "MM/DD/YYYY",
                          controller: controller.toDate.value,
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
                          controller.wareHouseValue.value = value;
                          controller.wareHouseID.value =
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
                            controller.reportValue.value = value;
                            controller.reportID.value =
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
                  showToast: () async {
                    List<Map<String, dynamic>> data =
                        await controller.fetchAllPurchaseReport();
                    setState(() {
                      purchaseListUpdate.value = data;
                    });
                  }),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing Purchase Reports",
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
                : purchaseListUpdate.isEmpty
                    ? const NotFound()
                    : SingleChildScrollView(
                        child: HorizontalPurchaseReportTableSection(
                        purchasesList: purchaseListUpdate,
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
