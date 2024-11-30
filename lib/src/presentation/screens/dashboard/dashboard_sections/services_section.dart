import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/widgets/alert_dialog/no_permission_box.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    super.initState();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
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
    final permission = user['userPermissions'];
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildServices(
                  context,
                  "Products",
                  "assets/icons/icon_image/products.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.purple, () {
                if (permission['view_permission_products']) {
                  Get.toNamed(AppRoutes.products);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Trading",
                  "assets/icons/icon_image/trading.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.green, () {
                if (permission['permission_sales_report']) {
                  Get.toNamed(AppRoutes.sales);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Expenses",
                  "assets/icons/icon_image/expense.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.orange, () {
                if (permission['add_permission_expenses']) {
                  Get.toNamed(AppRoutes.expense);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(context, "POS", "assets/icons/icon_image/pos.png",
                  ColorSchema.grey.withOpacity(0.1), ColorSchema.amber, () {
                if (permission['view_permission_products']) {
                  Get.toNamed(AppRoutes.posSales);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildServices(
                  context,
                  "Sale",
                  "assets/icons/icon_image/sales_list.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.red, () {
                if (permission['permission_sales_report']) {
                  Get.toNamed(AppRoutes.sales);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Purchase",
                  "assets/icons/icon_image/purchase_list.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.cyan, () {
                if (permission['view_permission_purchases']) {
                  Get.toNamed(AppRoutes.purchase);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Product",
                  "assets/icons/icon_image/products_list.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.teal, () {
                if (permission['view_permission_products']) {
                  Get.toNamed(AppRoutes.products);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Expense",
                  "assets/icons/icon_image/expense_list.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.pink, () {
                if (permission['view_permission_expenses']) {
                  Get.toNamed(AppRoutes.expenseList);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildServices(
                  context,
                  "Manage",
                  "assets/icons/icon_image/user_management.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.brown, () {
                if (permission['view_permission_users']) {
                  Get.toNamed(AppRoutes.management);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Report",
                  "assets/icons/icon_image/reports.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.indigo, () {
                if (permission['permission_sales_report']) {
                  Get.toNamed(AppRoutes.report);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Warehouse",
                  "assets/icons/icon_image/warehouse.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.lime, () {
                if (permission['view_permission_warehouses']) {
                  Get.toNamed(AppRoutes.warehouse);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
              buildServices(
                  context,
                  "Peoples",
                  "assets/icons/icon_image/customer.png",
                  ColorSchema.grey.withOpacity(0.1),
                  ColorSchema.blueGrey, () {
                if (permission['view_permission_customers']) {
                  Get.toNamed(AppRoutes.customer);
                } else {
                  showDialog(
                      context: Get.context!,
                      builder: (context) => const NoPermissionDialog());
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  InkWell buildServices(context, String service, String serviceIcon,
      Color serviceColor, Color serviceImageColor, Function onPressed) {
    return InkWell(
      onTap: () => onPressed(),
      child: Column(
        children: [
          Column(
            children: [
              Stack(alignment: Alignment.center, children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: serviceColor,
                      borderRadius: BorderRadius.circular(50)),
                ),
                ImageIcon(
                  AssetImage(
                    serviceIcon,
                  ),
                  color: serviceImageColor,
                  size: 35,
                )
              ]),
              const SizedBox(
                height: 5,
              ),
              Text(
                service,
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035)),
              )
            ],
          )
        ],
      ),
    );
  }
}
