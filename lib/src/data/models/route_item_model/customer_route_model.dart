import 'dart:convert';

import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> setupCustomerRoutes() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user') ?? '';

  final Map<String, dynamic> userMap = json.decode(userString);
  final permission = userMap['userPermissions'];
  final List<Map<String, dynamic>> customerRouteModel = [
    {
      'icon': "assets/icons/icon_svg/dashboard.svg",
      'label': 'Dashboard',
      'route': AppRoutes.dashboard
    },
    {
      'icon': "assets/icons/icon_svg/customer_icon.svg",
      'label': 'Customer',
      'route': permission['view_permission_customers']
          ? AppRoutes.customer
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/supplier_icon.svg",
      'label': 'Supplier',
      'route': permission['view_permission_suppliers']
          ? AppRoutes.supplier
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/biller_icon.svg",
      'label': 'Biller',
      'route': permission['view_permission_billers']
          ? AppRoutes.biller
          : AppRoutes.noPermission
    },
  ];
  return customerRouteModel;
}
