import 'package:flutter/material.dart';
import 'package:inventual/src/presentation/screens/analytics/analytics_sections/analytics_chart_section.dart';
import 'package:inventual/src/presentation/screens/analytics/analytics_sections/analytics_chart_section_two.dart';
import 'package:inventual/src/presentation/screens/analytics/analytics_sections/analytics_reports_section.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/utils/contstants.dart';

class AnalyticsMainScreen extends StatelessWidget {
  const AnalyticsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Analytics"),
      ),
      body: Container(
        color: ColorSchema.white70,
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            AnalyticsReportSection(),
            SizedBox(
              height: 20,
            ),
            AnalyticsChartSection(),
            SizedBox(
              height: 20,
            ),
            AnalyticsChartSectionTwo(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
