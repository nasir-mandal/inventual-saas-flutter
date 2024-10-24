import 'dart:convert';

import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> setupReportRoutes() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user') ?? '';

  final Map<String, dynamic> userMap = json.decode(userString);
  final permission = userMap['userPermissions'];
  final List<Map<String, dynamic>> reportsRouteModel = [
    {
      'icon': "assets/icons/icon_svg/dashboard.svg",
      'label': 'Dashboard',
      'route': AppRoutes.dashboard
    },
    {
      'icon': "assets/icons/icon_svg/sales_reports.svg",
      'label': 'Sales Report',
      'route': permission['permission_sales_report']
          ? AppRoutes.report
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/purchase_reports.svg",
      'label': 'Purchase Report',
      'route': permission['permission_pusrchases_report']
          ? AppRoutes.purchaseReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/payment_reports.svg",
      'label': 'Payment Report',
      'route': permission['permission_payments_report']
          ? AppRoutes.paymentReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/products_reports.svg",
      'label': 'Products Report',
      'route': permission['permission_products_report']
          ? AppRoutes.productsReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/stock_reports.svg",
      'label': 'Stock Report',
      'route': permission['permission_stocks_report']
          ? AppRoutes.stockReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/expense_reports.svg",
      'label': 'Expense Report',
      'route': permission['permission_expenses_report']
          ? AppRoutes.expenseReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/user_reports.svg",
      'label': 'User Report',
      'route': permission['permission_users_report']
          ? AppRoutes.userReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/customer_reports.svg",
      'label': 'Customer Report',
      'route': permission['permission_customers_report']
          ? AppRoutes.customerReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/warehouse_reports.svg",
      'label': 'Warehouse Report',
      'route': permission['permission_warehosues_report']
          ? AppRoutes.warehouseReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/supplier_reports.svg",
      'label': 'Supplier Report',
      'route': permission['permission_suppliers_report']
          ? AppRoutes.supplierReports
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/discount_reports.svg",
      'label': 'Discount Report',
      'route': permission['permission_discounts_report']
          ? AppRoutes.discountReport
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/tax_report.svg",
      'label': 'Tax Report',
      'route': permission['permission_taxes_report']
          ? AppRoutes.taxReport
          : AppRoutes.noPermission
    },
  ];
  return reportsRouteModel;
}
