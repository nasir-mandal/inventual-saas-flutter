import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/dashboard/dashboard_report_controller.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsReportSection extends StatefulWidget {
  const AnalyticsReportSection({Key? key}) : super(key: key);

  @override
  State<AnalyticsReportSection> createState() => _AnalyticsReportSectionState();
}

class _AnalyticsReportSectionState extends State<AnalyticsReportSection> {
  final DashboardReportController dashboardReportController =
      DashboardReportController();
  late Map<String, dynamic> settings = {};

  @override
  void initState() {
    dashboardReportController.fetchDashboardReport();
    super.initState();
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("settings");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Obx(() => dashboardReportController.isLoading.value
                  ? buildReports(
                      cardWidth,
                      ColorSchema.blue.withOpacity(0.08),
                      "Sales",
                      "...",
                      "assets/icons/icon_image/sales.png",
                      ColorSchema.blue,
                      ColorSchema.blue,
                      ColorSchema.blue.withOpacity(0.08),
                    )
                  : dashboardReportController.reportData.isEmpty
                      ? buildReports(
                          cardWidth,
                          ColorSchema.blue.withOpacity(0.08),
                          "Sales",
                          "00",
                          "assets/icons/icon_image/sales.png",
                          ColorSchema.blue,
                          ColorSchema.blue,
                          ColorSchema.blue.withOpacity(0.08),
                        )
                      : buildReports(
                          cardWidth,
                          ColorSchema.blue.withOpacity(0.08),
                          "Sales",
                          "${settings["currency_symbol"] ?? '\$'}${dashboardReportController.reportData['sales'].toString()}",
                          "assets/icons/icon_image/sales.png",
                          ColorSchema.blue,
                          ColorSchema.blue,
                          ColorSchema.blue.withOpacity(0.08),
                        )),
              const SizedBox(
                width: 10,
              ),
              Obx(() => dashboardReportController.isLoading.value
                  ? buildReports(
                      cardWidth,
                      ColorSchema.green.withOpacity(0.08),
                      "Purchase",
                      "...",
                      "assets/icons/icon_image/purchase.png",
                      ColorSchema.green,
                      ColorSchema.green,
                      ColorSchema.green.withOpacity(0.08),
                    )
                  : dashboardReportController.reportData.isEmpty
                      ? buildReports(
                          cardWidth,
                          ColorSchema.green.withOpacity(0.08),
                          "Purchase",
                          "00",
                          "assets/icons/icon_image/purchase.png",
                          ColorSchema.green,
                          ColorSchema.green,
                          ColorSchema.green.withOpacity(0.08),
                        )
                      : buildReports(
                          cardWidth,
                          ColorSchema.green.withOpacity(0.08),
                          "Purchase",
                          "${settings["currency_symbol"] ?? '\$'}${dashboardReportController.reportData['purchase'].toString()}",
                          "assets/icons/icon_image/purchase.png",
                          ColorSchema.green,
                          ColorSchema.green,
                          ColorSchema.green.withOpacity(0.08),
                        )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Obx(() => dashboardReportController.isLoading.value
                  ? buildReports(
                      cardWidth,
                      ColorSchema.purple.withOpacity(0.08),
                      "Expense",
                      "...",
                      "assets/icons/icon_image/expense.png",
                      ColorSchema.purple,
                      ColorSchema.purple,
                      ColorSchema.purple.withOpacity(0.08),
                    )
                  : dashboardReportController.reportData.isEmpty
                      ? buildReports(
                          cardWidth,
                          ColorSchema.purple.withOpacity(0.08),
                          "Expense",
                          "00",
                          "assets/icons/icon_image/expense.png",
                          ColorSchema.purple,
                          ColorSchema.purple,
                          ColorSchema.purple.withOpacity(0.08),
                        )
                      : buildReports(
                          cardWidth,
                          ColorSchema.purple.withOpacity(0.08),
                          "Expense",
                          "${settings["currency_symbol"] ?? '\$'}${dashboardReportController.reportData['expense'].toString()}",
                          "assets/icons/icon_image/expense.png",
                          ColorSchema.purple,
                          ColorSchema.purple,
                          ColorSchema.purple.withOpacity(0.08),
                        )),
              const SizedBox(
                width: 10,
              ),
              Obx(() => dashboardReportController.isLoading.value
                  ? buildReports(
                      cardWidth,
                      ColorSchema.orange.withOpacity(0.08),
                      "Profit",
                      "00",
                      "assets/icons/icon_image/profit.png",
                      ColorSchema.orange,
                      ColorSchema.orange,
                      ColorSchema.orange.withOpacity(0.08),
                    )
                  : dashboardReportController.reportData.isEmpty
                      ? buildReports(
                          cardWidth,
                          ColorSchema.orange.withOpacity(0.08),
                          "Profit",
                          "00",
                          "assets/icons/icon_image/profit.png",
                          ColorSchema.orange,
                          ColorSchema.orange,
                          ColorSchema.orange.withOpacity(0.08),
                        )
                      : buildReports(
                          cardWidth,
                          ColorSchema.orange.withOpacity(0.08),
                          "Profit",
                          "${settings["currency_symbol"] ?? '\$'}${dashboardReportController.reportData['profit'].toString()}",
                          "assets/icons/icon_image/expense.png",
                          ColorSchema.orange,
                          ColorSchema.orange,
                          ColorSchema.orange.withOpacity(0.08),
                        )),
            ],
          ),
        ],
      ),
    );
  }

  Expanded buildReports(
    double cardWidth,
    Color reportColor,
    String reportTitle,
    String balance,
    String reportIcon,
    Color reportIconColor,
    Color balanceColor,
    Color splashPressedColor,
  ) {
    return Expanded(
      child: InkWell(
        splashColor: splashPressedColor,
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Card(
          color: reportColor,
          surfaceTintColor: ColorSchema.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(alignment: Alignment.center, children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorSchema.white54,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  ImageIcon(
                    AssetImage(
                      reportIcon,
                    ),
                    color: reportIconColor,
                    size: 30,
                  )
                ]),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reportTitle,
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: cardWidth * 0.04,
                            color: ColorSchema.lightBlack,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        balance,
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: balanceColor,
                            fontSize: cardWidth * 0.040,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
