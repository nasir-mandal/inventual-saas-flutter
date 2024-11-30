import 'dart:convert'; // Add this import for json.decode

import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> setupDashboardRoutes() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user') ?? '';

  final Map<String, dynamic> userMap = json.decode(userString);
  final permission = userMap['userPermissions'];

  final List<Map<String, dynamic>> dashboardRouteModel = <Map<String, dynamic>>[
    {
      'icon': "assets/icons/icon_svg/dashboard.svg",
      'label': 'Dashboard',
      'route': AppRoutes.dashboard
    },
    {
      'icon': "assets/icons/icon_svg/products.svg",
      'label': 'Products',
      'route': permission['view_permission_products']
          ? AppRoutes.products
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/trading_icon.svg",
      'label': 'Trading',
      'route': permission['permission_sales_report']
          ? AppRoutes.sales
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/expenses.svg",
      'label': 'Expense',
      'route': permission['add_permission_expenses']
          ? AppRoutes.expense
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/pos_icon.svg",
      'label': 'POS',
      'route': permission['view_permission_products']
          ? AppRoutes.posSales
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/management.svg",
      'label': 'Management',
      'route': permission['view_permission_users']
          ? AppRoutes.management
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/reports.svg",
      'label': 'Reports',
      'route': permission['permission_sales_report']
          ? AppRoutes.report
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/warehouse.svg",
      'label': 'Warehouse',
      'route': permission['view_permission_warehouses']
          ? AppRoutes.warehouse
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/customer.svg",
      'label': 'Peoples',
      'route': permission['view_permission_customers']
          ? AppRoutes.customer
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/profile.svg",
      'label': 'Profile',
      'route': AppRoutes.profile
    },
  ];

  return dashboardRouteModel;
}
