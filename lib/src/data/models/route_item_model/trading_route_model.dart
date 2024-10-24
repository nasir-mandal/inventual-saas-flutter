import 'dart:convert';

import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> setupTradingRoutes() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user') ?? '';

  final Map<String, dynamic> userMap = json.decode(userString);
  final permission = userMap['userPermissions'];
  final List<Map<String, dynamic>> tradingRouteModel = [
    {
      'icon': "assets/icons/icon_svg/dashboard.svg",
      'label': 'Dashboard',
      'route': AppRoutes.dashboard
    },
    {
      'icon': "assets/icons/icon_svg/sale_icon.svg",
      'label': 'Sale',
      'route': permission['permission_sales_report']
          ? AppRoutes.sales
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/sale_icon.svg",
      'label': 'Sales Return',
      'route': permission['view_permission_sales_return']
          ? AppRoutes.salesReturn
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/purchase_icon.svg",
      'label': 'Purchase',
      'route': permission['view_permission_purchases']
          ? AppRoutes.purchase
          : AppRoutes.noPermission
    },
  ];
  return tradingRouteModel;
}
