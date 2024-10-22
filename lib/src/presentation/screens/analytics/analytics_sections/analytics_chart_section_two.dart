import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/dashboard/dashboard_report_controller.dart';
import 'package:inventual/src/utils/contstants.dart';

class AnalyticsChartSectionTwo extends StatefulWidget {
  const AnalyticsChartSectionTwo({super.key});

  final Color leftBarColor = ColorSchema.profileColor1;
  final Color rightBarColor = ColorSchema.analyticsColor2;
  final Color avgColor = ColorSchema.analyticsColor1;

  @override
  State<StatefulWidget> createState() => _AnalyticsChartSectionTwoState();
}

class _AnalyticsChartSectionTwoState extends State<AnalyticsChartSectionTwo> {
  final DashboardReportController dashboardReportController =
      DashboardReportController();
  final double width = 10;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  bool isLoading = true;
  double maxYValue = 20; // Set a default maxY value

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await dashboardReportController.fetchDashboardReport();
    final stockData = dashboardReportController.stockDataReport;

    final months = stockData['years'] as List<dynamic>;
    final stock = stockData['stock'] as List<dynamic>;
    final quantity = stockData['quantity'] as List<dynamic>;

    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < months.length; i++) {
      barGroups.add(makeGroupData(
        i,
        stock[i].toDouble(),
        quantity[i].toDouble(),
      ));
    }

    // Determine the max value between stock and quantity to set maxY dynamically
    maxYValue = [
      ...stock.map((e) => e.toDouble()),
      ...quantity.map((e) => e.toDouble())
    ].reduce((a, b) => a > b ? a : b);

    // Set maxYValue slightly higher than the highest value to provide some padding
    maxYValue *= 1.1;

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
              'Stock Analysis',
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
    final months =
        dashboardReportController.stockDataReport['years'] as List<dynamic>;
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
          height: 5,
          color: ColorSchema.red.withOpacity(0.8),
        ),
        SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 5,
          color: ColorSchema.red.withOpacity(1),
        ),
      ],
    );
  }
}
