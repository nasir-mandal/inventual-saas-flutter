import 'dart:convert';

import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> setupProductRoutes() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user') ?? '';

  final Map<String, dynamic> userMap = json.decode(userString);
  final permission = userMap['userPermissions'];

  final List<Map<String, dynamic>> ProductsRouteModel = <Map<String, dynamic>>[
    {
      'icon': "assets/icons/icon_svg/dashboard.svg",
      'label': 'Dashboard',
      'route': AppRoutes.dashboard
    },
    {
      'icon': "assets/icons/icon_svg/product_list.svg",
      'label': 'Product List',
      'route': AppRoutes.products
    },
    {
      'icon': "assets/icons/icon_svg/add_product.svg",
      'label': 'Add Product',
      'route': permission['add_permission_products']
          ? AppRoutes.addProduct
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/category.svg",
      'label': 'Category',
      'route': permission['view_permission_categories']
          ? AppRoutes.category
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/brand.svg",
      'label': 'Brand',
      'route': permission['view_permission_brands']
          ? AppRoutes.brand
          : AppRoutes.noPermission
    },
    {
      'icon': "assets/icons/icon_svg/unit_management.svg",
      'label': 'Unit Management',
      'route': permission['view_permission_units']
          ? AppRoutes.unit
          : AppRoutes.noPermission
    },
  ];
  return ProductsRouteModel;
}
