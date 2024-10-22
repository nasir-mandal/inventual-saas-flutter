import 'dart:convert';

import 'package:inventual/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> setupExpenseRoutes() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user') ?? '';

  final Map<String, dynamic> userMap = json.decode(userString);
  final permission = userMap['userPermissions'];
  final List<Map<String, dynamic>> expenseRouteModel = [
    {
      'icon': "assets/icons/icon_svg/dashboard.svg",
      'label': 'Dashboard',
      'route': AppRoutes.dashboard
    },
    {
      'icon': "assets/icons/icon_svg/add_expense.svg",
      'label': 'Add Expense',
      'route': permission['add_permission_expenses']
          ? AppRoutes.expense
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/expense_list.svg",
      'label': 'Expense List',
      'route': permission['view_permission_expenses']
          ? AppRoutes.expenseList
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/expense_category.svg",
      'label': 'Expense Category',
      'route': permission['view_permission_categories']
          ? AppRoutes.expenseCategory
          : AppRoutes.noPermission
    },
  ];
  return expenseRouteModel;
}
