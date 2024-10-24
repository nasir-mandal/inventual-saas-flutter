import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventual_saas/src/presentation/screens/dashboard/dashboard_sections/carousel_section.dart';
import 'package:inventual_saas/src/presentation/screens/dashboard/dashboard_sections/header_section.dart';
import 'package:inventual_saas/src/presentation/screens/dashboard/dashboard_sections/services_section.dart';
import 'package:inventual_saas/src/presentation/screens/dashboard/dashboard_sections/today_reports_section.dart';
import 'package:inventual_saas/src/presentation/widgets/drawer/dashboard_drawer.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:sidebarx/sidebarx.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({Key? key}) : super(key: key);
  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  final controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _key,
          drawer:
              DashboardDrawer(routeName: "Dashboard", controller: controller),
          appBar: isSmallScreen
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: DashboardHeaderSection(
                    openDrawer: () {
                      if (!Platform.isAndroid && !Platform.isIOS) {
                        controller.setExtended(true);
                      }
                      _key.currentState?.openDrawer();
                    },
                  ),
                )
              : null,
          body: Container(
            color: ColorSchema.white70,
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                TodayReportsSection(),
                ServicesSection(),
                CarouselSection(),
              ],
            ),
          ),
        ));
  }
}
