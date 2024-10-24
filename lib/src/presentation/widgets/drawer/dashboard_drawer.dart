import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/authentication.dart';
import 'package:inventual_saas/src/data/models/route_item_model/customer_route_model.dart';
import 'package:inventual_saas/src/data/models/route_item_model/dashboar_route_model.dart';
import 'package:inventual_saas/src/data/models/route_item_model/expense_route_model.dart';
import 'package:inventual_saas/src/data/models/route_item_model/products_route_model.dart';
import 'package:inventual_saas/src/data/models/route_item_model/reports_route_model.dart';
import 'package:inventual_saas/src/data/models/route_item_model/trading_route_model.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

// Import the file
class DashboardDrawer extends StatefulWidget {
  final String routeName;
  final SidebarXController controller;

  const DashboardDrawer({
    super.key,
    required this.routeName,
    required this.controller,
  });

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  late List<Map<String, dynamic>> items = [];
  late List<Map<String, dynamic>> productRoutes = [];
  late List<Map<String, dynamic>> tradingRoutes = [];
  late List<Map<String, dynamic>> expenseRoutes = [];
  late List<Map<String, dynamic>> reportsRoutes = [];
  late List<Map<String, dynamic>> customerRoutes = [];
  late Map<String, dynamic> user = {};

  final UserAuthenticationController _controller =
      UserAuthenticationController();
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    loadUser().then(
      (value) {
        setState(() {
          user = value ?? {};
        });
      },
    );

    setupProductRoutes().then((routes) {
      setState(() {
        productRoutes = routes;
      });
    });
    setupTradingRoutes().then((routes) {
      setState(() {
        tradingRoutes = routes;
      });
    });
    setupExpenseRoutes().then((routes) {
      setState(() {
        expenseRoutes = routes;
      });
    });
    setupReportRoutes().then((routes) {
      setState(() {
        reportsRoutes = routes;
      });
    });
    setupCustomerRoutes().then((routes) {
      setState(() {
        customerRoutes = routes;
      });
    });

    setupDashboardRoutes().then((routes) {
      setState(() {
        items = routes;
        switch (widget.routeName) {
          case "Dashboard":
            items = [
              ...items,
              {
                'icon': "assets/icons/icon_svg/log-out.svg",
                'label': 'Log Out',
                'route': AppRoutes.login
              }
            ];
            break;
          case "Products":
            items = productRoutes;
            break;
          case "Reports":
            items = reportsRoutes;
            break;
          case "Expense":
            items = expenseRoutes;
            break;
          case "Customer":
            items = customerRoutes;
            break;
          case "Trading":
            items = tradingRoutes;
            break;
          default:
            // Keep the default items if routeName does not match any case
            items = items;
        }
      });
    });
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget.controller,
      theme: SidebarXTheme(
        selectedItemPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        textStyle: GoogleFonts.nunito(
            textStyle: const TextStyle(
                color: ColorSchema.lightBlack,
                fontSize: 17,
                fontWeight: FontWeight.w500)),
        selectedTextStyle: const TextStyle(
            color: ColorSchema.lightBlack,
            fontSize: 16,
            fontWeight: FontWeight.w600),
        itemTextPadding: const EdgeInsets.only(left: 10),
        selectedItemTextPadding: const EdgeInsets.only(left: 10),
        selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorSchema.blue.withOpacity(0.05)),
        iconTheme: IconThemeData(
          color: ColorSchema.black.withOpacity(0.7),
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
          width: 300, padding: EdgeInsets.symmetric(horizontal: 12)),
      showToggleButton: false,
      headerBuilder: (context, extended) {
        if (widget.routeName == "Dashboard") {
          return Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage:
                      user['image'] != null && user['image'].isNotEmpty
                          ? NetworkImage(user['image']) as ImageProvider
                          : const AssetImage(
                                  "assets/images/avatar/placeholder-user.png")
                              as ImageProvider,
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user['email'] ?? 'Unknown User',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    textStyle: const TextStyle(color: ColorSchema.grey)),
              ),
              Text(
                user['role'] ?? 'Unknown Role',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                  color: ColorSchema.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
              ),
            ],
          );
        } else {
          return const SizedBox(
            height: 20,
          );
        }
      },
      items: items.map((item) {
        return SidebarXItem(
          iconWidget: SvgPicture.asset(
            item['icon'],
            height: 20,
            color: ColorSchema.lightBlack,
          ),
          label: item['label'],
          onTap: () {
            if (item['label'] == 'Log Out') {
              _controller.logOut();
              userController.logOut();
            }
            Get.toNamed(item['route']);
          },
        );
      }).toList(),
    );
  }
}
