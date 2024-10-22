import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/dashboard/dashboard_report_controller.dart';
import 'package:inventual/src/utils/contstants.dart';

class AnalyticsChartSection extends StatefulWidget {
  const AnalyticsChartSection({super.key});
  final Color leftBarColor = ColorSchema.profileColor1;
  final Color rightBarColor = ColorSchema.analyticsColor2;
  final Color avgColor = ColorSchema.analyticsColor1;

  @override
  State<StatefulWidget> createState() => AnalyticsChartSectionState();
}

class AnalyticsChartSectionState extends State<AnalyticsChartSection> {
  final DashboardReportController dashboardReportController =
      DashboardReportController();
  final double width = 10;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  bool isLoading = true;
  double maxYValue = 10;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await dashboardReportController.fetchDashboardReport();
    final profitLossData = dashboardReportController.profitLossDataReport;

    final months = profitLossData['months'] as List<dynamic>;
    final profits = profitLossData['profit'] as List<dynamic>;
    final losses = profitLossData['loss'] as List<dynamic>;

    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < months.length; i++) {
      barGroups.add(makeGroupData(
        i,
        profits[i].toDouble(),
        losses[i].toDouble(),
      ));
    }

    // Determine the max value between profits and losses to set maxY dynamically
    maxYValue = [
      ...profits.map((e) => e.toDouble()),
      ...losses.map((e) => e.toDouble())
    ].reduce((a, b) => a > b ? a : b);

    // Ensure the maxYValue is at least slightly higher than the highest value
    maxYValue = (maxYValue == 0) ? 10 : maxYValue * 1.1;

    setState(() {
      rawBarGroups = barGroups;
      showingBarGroups = rawBarGroups;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(
              color: ColorSchema.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: ColorSchema.primaryColor.withOpacity(0.7),
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Profit & Loss',
              style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                color: ColorSchema.primaryColor.withOpacity(0.7),
                fontSize: MediaQuery.of(context).size.width * 0.045,
                fontWeight: FontWeight.bold,
              )),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxYValue,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: ColorSchema.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: maxYValue / 5,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final style = GoogleFonts.nunito(
        textStyle: TextStyle(
      color: ColorSchema.grey,
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.width * 0.032,
    ));

    String text;
    if (value == 0) {
      text = '0';
    } else if (value == maxYValue / 5) {
      text = '${(maxYValue / 5).round()}';
    } else if (value == maxYValue * 2 / 5) {
      text = '${(maxYValue * 2 / 5).round()}';
    } else if (value == maxYValue * 3 / 5) {
      text = '${(maxYValue * 3 / 5).round()}';
    } else if (value == maxYValue * 4 / 5) {
      text = '${(maxYValue * 4 / 5).round()}';
    } else if (value == maxYValue) {
      text = '${maxYValue.round()}';
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final months = dashboardReportController.profitLossDataReport['months']
        as List<dynamic>;
    final monthNames = months.cast<String>();

    final Widget text = Text(
      monthNames[value.toInt()],
      style: GoogleFonts.nunito(
          textStyle: TextStyle(
        color: ColorSchema.grey,
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.032,
      )),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    final width = MediaQuery.of(context).size.width * 0.007;
    final space = MediaQuery.of(context).size.width * 0.01;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 5,
          color: ColorSchema.red.withOpacity(0.4),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 16,
          color: ColorSchema.green.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 26,
          color: ColorSchema.pink.withOpacity(1),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 16,
          color: ColorSchema.cyan.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 5,
          color: ColorSchema.deepOrangeAccent.withOpacity(0.4),
        ),
      ],
    );
  }
}
