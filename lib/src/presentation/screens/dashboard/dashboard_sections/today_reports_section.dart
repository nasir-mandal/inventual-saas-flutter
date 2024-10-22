import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/dashboard/dashboard_report_controller.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayReportsSection extends StatefulWidget {
  const TodayReportsSection({
    super.key,
  });

  @override
  State<TodayReportsSection> createState() => _TodayReportsSectionState();
}

class _TodayReportsSectionState extends State<TodayReportsSection> {
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorSchema.blue.withOpacity(0.08)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today Reports",
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    color: ColorSchema.lightBlack,
                  )),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.analytics);
                  },
                  child: Text(
                    "View",
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                      color: ColorSchema.primaryColor.withOpacity(0.7),
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => dashboardReportController.isLoading.value
                    ? buildReports(
                        "Sales",
                        "${settings['currency_symbol']}00",
                        ColorSchema.lightBlueAccent.withOpacity(0.12),
                        "assets/icons/icon_svg/sale_service_icon.svg",
                        screenWidth,
                        context,
                      )
                    : dashboardReportController.reportData.isEmpty
                        ? buildReports(
                            "Sales",
                            "${settings['currency_symbol']}00",
                            ColorSchema.lightBlueAccent.withOpacity(0.12),
                            "assets/icons/icon_svg/sale_service_icon.svg",
                            screenWidth,
                            context,
                          )
                        : buildReports(
                            "Sales",
                            dashboardReportController.reportData['sales']
                                .toString(),
                            ColorSchema.lightBlueAccent.withOpacity(0.12),
                            "assets/icons/icon_svg/sale_service_icon.svg",
                            screenWidth,
                            context,
                          )),
                Obx(() => dashboardReportController.isLoading.value
                    ? buildReports(
                        "Purchase",
                        "00",
                        ColorSchema.purple.withOpacity(0.06),
                        "assets/icons/icon_svg/purchase_service_icon.svg",
                        screenWidth,
                        context,
                      )
                    : dashboardReportController.reportData.isEmpty
                        ? buildReports(
                            "Purchase",
                            "00",
                            ColorSchema.purple.withOpacity(0.06),
                            "assets/icons/icon_svg/purchase_service_icon.svg",
                            screenWidth,
                            context,
                          )
                        : buildReports(
                            "Purchase",
                            dashboardReportController.reportData['purchase']
                                .toString(),
                            ColorSchema.purple.withOpacity(0.06),
                            "assets/icons/icon_svg/purchase_service_icon.svg",
                            screenWidth,
                            context,
                          )),
                Obx(() => dashboardReportController.isLoading.value
                    ? buildReports(
                        "Expense",
                        "00",
                        ColorSchema.teal.withOpacity(0.08),
                        "assets/icons/icon_svg/expenses_icon.svg",
                        screenWidth,
                        context,
                      )
                    : dashboardReportController.reportData.isEmpty
                        ? buildReports(
                            "Expense",
                            "00",
                            ColorSchema.teal.withOpacity(0.08),
                            "assets/icons/icon_svg/expenses_icon.svg",
                            screenWidth,
                            context,
                          )
                        : buildReports(
                            "Expense",
                            dashboardReportController.reportData['expense']
                                .toString(),
                            ColorSchema.teal.withOpacity(0.08),
                            "assets/icons/icon_svg/expenses_icon.svg",
                            screenWidth,
                            context,
                          )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildReports(
    String title,
    String amount,
    Color reportColor,
    reportIcon,
    double screenWidth,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.analytics);
      },
      child: Container(
        width: screenWidth * 0.27,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: reportColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorSchema.white54,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    reportIcon,
                    width: 20,
                  )),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: ColorSchema.lightBlack,
              )),
            ),
            Text.rich(
              TextSpan(
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width * 0.040,
                  color: ColorSchema.lightBlack,
                )),
                children: [
                  TextSpan(text: "${settings['currency_symbol'] ?? '\$'}"),
                  TextSpan(text: amount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
