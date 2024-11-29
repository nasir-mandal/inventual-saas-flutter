import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/presentation/widgets/toast/toast_helper.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthenticationController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = false.obs;
  final RxBool notFound = true.obs;
  final Rx<TextEditingController> username = TextEditingController().obs;
  final Rx<TextEditingController> password = TextEditingController().obs;

  Future<bool> login(BuildContext context) async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? supplierKey = prefs.getString("supplier_key");
      Map<String, String> requestBody = {
        "username": username.value.text,
        "password": password.value.text,
      };
      print(requestBody);
      final String url = "${await AppStrings.getBaseUrlV1()}users/login";
      final jsonResponse = await _apiServices.loginApi(requestBody, url);

      if (jsonResponse != null && jsonResponse['success']) {
        Map<String, dynamic> userData = jsonResponse["data"];
        Map<String, dynamic> permissions = jsonResponse["permissions"];
        await prefs.setString("token", userData["bearer_token"] ?? '');
        String? imagePath;
        if (userData["image"] != null && userData["image"]["path"] != null) {
          imagePath = await AppStrings.getImageUrl(userData["image"]["path"]);
        }
        int roleId = (userData["roles"] != null && userData["roles"].isNotEmpty)
            ? userData["roles"][0]['id'] ?? 0
            : 0;

        Map<String, dynamic> userPermissions = {
          "permission_parent_products_view_all":
              permissions["permission_parent_products_view_all"] ?? false,
          "permission_parent_products_add_all":
              permissions["permission_parent_products_add_all"] ?? false,
          "permission_parent_products_edit_all":
              permissions["permission_parent_products_edit_all"] ?? false,
          "permission_parent_products_delete_all":
              permissions["permission_parent_products_delete_all"] ?? false,
          "permission_parent_trading_view_all":
              permissions["permission_parent_trading_view_all"] ?? false,
          "permission_parent_trading_add_all":
              permissions["permission_parent_trading_add_all"] ?? false,
          "permission_parent_trading_edit_all":
              permissions["permission_parent_trading_edit_all"] ?? false,
          "permission_parent_trading_delete_all":
              permissions["permission_parent_trading_delete_all"] ?? false,
          "permission_parent_expenses_view_all":
              permissions["permission_parent_expenses_view_all"] ?? false,
          "permission_parent_expenses_add_all":
              permissions["permission_parent_expenses_add_all"] ?? false,
          "permission_parent_expenses_edit_all":
              permissions["permission_parent_expenses_edit_all"] ?? false,
          "permission_parent_expenses_delete_all":
              permissions["permission_parent_expenses_delete_all"] ?? false,
          "permission_parent_people_view_all":
              permissions["permission_parent_people_view_all"] ?? false,
          "permission_parent_people_add_all":
              permissions["permission_parent_people_add_all"] ?? false,
          "permission_parent_people_edit_all":
              permissions["permission_parent_people_edit_all"] ?? false,
          "permission_parent_people_delete_all":
              permissions["permission_parent_people_delete_all"] ?? false,
          "permission_parent_others_view_all":
              permissions["permission_parent_others_view_all"] ?? false,
          "permission_parent_others_add_all":
              permissions["permission_parent_others_add_all"] ?? false,
          "permission_parent_others_edit_all":
              permissions["permission_parent_others_edit_all"] ?? false,
          "permission_parent_others_delete_all":
              permissions["permission_parent_others_delete_all"] ?? false,
          "view_permission_products":
              permissions["view_permission_products"] ?? false,
          "view_permission_brands":
              permissions["view_permission_brands"] ?? false,
          "view_permission_units":
              permissions["view_permission_units"] ?? false,
          "view_permission_bardcodes":
              permissions["view_permission_bardcodes"] ?? false,
          "view_permission_adjustments":
              permissions["view_permission_adjustments"] ?? false,
          "view_permission_sales":
              permissions["view_permission_sales"] ?? false,
          "view_permission_pos_sales":
              permissions["view_permission_pos_sales"] ?? false,
          "view_permission_sales_return":
              permissions["view_permission_sales_return"] ?? false,
          "view_permission_sales_payment":
              permissions["view_permission_sales_payment"] ?? false,
          "view_permission_purchases":
              permissions["view_permission_purchases"] ?? false,
          "view_permission_purchases_return":
              permissions["view_permission_purchases_return"] ?? false,
          "view_permission_expenses":
              permissions["view_permission_expenses"] ?? false,
          "view_permission_customers":
              permissions["view_permission_customers"] ?? false,
          "view_permission_suppliers":
              permissions["view_permission_suppliers"] ?? false,
          "view_permission_billers":
              permissions["view_permission_billers"] ?? false,
          "view_permission_users":
              permissions["view_permission_users"] ?? false,
          "view_permission_roles":
              permissions["view_permission_roles"] ?? false,
          "view_permission_categories":
              permissions["view_permission_categories"] ?? false,
          "view_permission_types":
              permissions["view_permission_types"] ?? false,
          "view_permission_taxes":
              permissions["view_permission_taxes"] ?? false,
          "view_permission_variants":
              permissions["view_permission_variants"] ?? false,
          "view_permission_transfers":
              permissions["view_permission_transfers"] ?? false,
          "view_permission_companies":
              permissions["view_permission_companies"] ?? false,
          "view_permission_warehouses":
              permissions["view_permission_warehouses"] ?? false,
          "view_permission_countries":
              permissions["view_permission_countries"] ?? false,
          "permission_sales_report":
              permissions["permission_sales_report"] ?? false,
          "permission_pusrchases_report":
              permissions["permission_pusrchases_report"] ?? false,
          "permission_payments_report":
              permissions["permission_payments_report"] ?? false,
          "permission_products_report":
              permissions["permission_products_report"] ?? false,
          "permission_stocks_report":
              permissions["permission_stocks_report"] ?? false,
          "permission_expenses_report":
              permissions["permission_expenses_report"] ?? false,
          "permission_users_report":
              permissions["permission_users_report"] ?? false,
          "permission_customers_report":
              permissions["permission_customers_report"] ?? false,
          "permission_warehosues_report":
              permissions["permission_warehosues_report"] ?? false,
          "permission_suppliers_report":
              permissions["permission_suppliers_report"] ?? false,
          "permission_discounts_report":
              permissions["permission_discounts_report"] ?? false,
          "permission_taxes_report":
              permissions["permission_taxes_report"] ?? false,
          "permission_shipping_charges":
              permissions["permission_shipping_charges"] ?? false,
          "permission_general_settings":
              permissions["permission_general_settings"] ?? false,
          "permission_permission_settings":
              permissions["permission_permission_settings"] ?? false,
          "add_permission_products":
              permissions["add_permission_products"] ?? false,
          "add_permission_brands":
              permissions["add_permission_brands"] ?? false,
          "add_permission_units": permissions["add_permission_units"] ?? false,
          "add_permission_bardcodes":
              permissions["add_permission_bardcodes"] ?? false,
          "add_permission_adjustments":
              permissions["add_permission_adjustments"] ?? false,
          "add_permission_sales": permissions["add_permission_sales"] ?? false,
          "add_permission_pos_sales":
              permissions["add_permission_pos_sales"] ?? false,
          "add_permission_sales_return":
              permissions["add_permission_sales_return"] ?? false,
          "add_permission_sales_payment":
              permissions["add_permission_sales_payment"] ?? false,
          "add_permission_purchases":
              permissions["add_permission_purchases"] ?? false,
          "add_permission_purchases_return":
              permissions["add_permission_purchases_return"] ?? false,
          "add_permission_expenses":
              permissions["add_permission_expenses"] ?? false,
          "add_permission_customers":
              permissions["add_permission_customers"] ?? false,
          "add_permission_suppliers":
              permissions["add_permission_suppliers"] ?? false,
          "add_permission_billers":
              permissions["add_permission_billers"] ?? false,
          "add_permission_users": permissions["add_permission_users"] ?? false,
          "add_permission_roles": permissions["add_permission_roles"] ?? false,
          "add_permission_categories":
              permissions["add_permission_categories"] ?? false,
          "add_permission_types": permissions["add_permission_types"] ?? false,
          "add_permission_taxes": permissions["add_permission_taxes"] ?? false,
          "add_permission_variants":
              permissions["add_permission_variants"] ?? false,
          "add_permission_transfers":
              permissions["add_permission_transfers"] ?? false,
          "add_permission_companies":
              permissions["add_permission_companies"] ?? false,
          "add_permission_warehouses":
              permissions["add_permission_warehouses"] ?? false,
          "add_permission_countries":
              permissions["add_permission_countries"] ?? false,
          "edit_permission_products":
              permissions["edit_permission_products"] ?? false,
          "edit_permission_brands":
              permissions["edit_permission_brands"] ?? false,
          "edit_permission_units":
              permissions["edit_permission_units"] ?? false,
          "edit_permission_bardcodes":
              permissions["edit_permission_bardcodes"] ?? false,
          "edit_permission_adjustments":
              permissions["edit_permission_adjustments"] ?? false,
          "edit_permission_sales":
              permissions["edit_permission_sales"] ?? false,
          "edit_permission_pos_sales":
              permissions["edit_permission_pos_sales"] ?? false,
          "edit_permission_sales_return":
              permissions["edit_permission_sales_return"] ?? false,
          "edit_permission_sales_payment":
              permissions["edit_permission_sales_payment"] ?? false,
          "edit_permission_purchases":
              permissions["edit_permission_purchases"] ?? false,
          "edit_permission_purchases_return":
              permissions["edit_permission_purchases_return"] ?? false,
          "edit_permission_expenses":
              permissions["edit_permission_expenses"] ?? false,
          "edit_permission_customers":
              permissions["edit_permission_customers"] ?? false,
          "edit_permission_suppliers":
              permissions["edit_permission_suppliers"] ?? false,
          "edit_permission_billers":
              permissions["edit_permission_billers"] ?? false,
          "edit_permission_users":
              permissions["edit_permission_users"] ?? false,
          "edit_permission_roles":
              permissions["edit_permission_roles"] ?? false,
          "edit_permission_categories":
              permissions["edit_permission_categories"] ?? false,
          "edit_permission_types":
              permissions["edit_permission_types"] ?? false,
          "edit_permission_taxes":
              permissions["edit_permission_taxes"] ?? false,
          "edit_permission_variants":
              permissions["edit_permission_variants"] ?? false,
          "edit_permission_transfers":
              permissions["edit_permission_transfers"] ?? false,
          "edit_permission_companies":
              permissions["edit_permission_companies"] ?? false,
          "edit_permission_warehouses":
              permissions["edit_permission_warehouses"] ?? false,
          "edit_permission_countries":
              permissions["edit_permission_countries"] ?? false,
          "delete_permission_products":
              permissions["delete_permission_products"] ?? false,
          "delete_permission_brands":
              permissions["delete_permission_brands"] ?? false,
          "delete_permission_units":
              permissions["delete_permission_units"] ?? false,
          "delete_permission_bardcodes":
              permissions["delete_permission_bardcodes"] ?? false,
          "delete_permission_adjustments":
              permissions["delete_permission_adjustments"] ?? false,
          "delete_permission_sales":
              permissions["delete_permission_sales"] ?? false,
          "delete_permission_pos_sales":
              permissions["delete_permission_pos_sales"] ?? false,
          "delete_permission_sales_return":
              permissions["delete_permission_sales_return"] ?? false,
          "delete_permission_sales_payment":
              permissions["delete_permission_sales_payment"] ?? false,
          "delete_permission_purchases":
              permissions["delete_permission_purchases"] ?? false,
          "delete_permission_purchases_return":
              permissions["delete_permission_purchases_return"] ?? false,
          "delete_permission_expenses":
              permissions["delete_permission_expenses"] ?? false,
          "delete_permission_customers":
              permissions["delete_permission_customers"] ?? false,
          "delete_permission_suppliers":
              permissions["delete_permission_suppliers"] ?? false,
          "delete_permission_billers":
              permissions["delete_permission_billers"] ?? false,
          "delete_permission_users":
              permissions["delete_permission_users"] ?? false,
          "delete_permission_roles":
              permissions["delete_permission_roles"] ?? false,
          "delete_permission_categories":
              permissions["delete_permission_categories"] ?? false,
          "delete_permission_types":
              permissions["delete_permission_types"] ?? false,
          "delete_permission_taxes":
              permissions["delete_permission_taxes"] ?? false,
          "delete_permission_variants":
              permissions["delete_permission_variants"] ?? false,
          "delete_permission_transfers":
              permissions["delete_permission_transfers"] ?? false,
          "delete_permission_companies":
              permissions["delete_permission_companies"] ?? false,
          "delete_permission_warehouses":
              permissions["delete_permission_warehouses"] ?? false,
          "delete_permission_countries":
              permissions["delete_permission_countries"] ?? false,
        };

        Map<String, dynamic> user = {
          "user_id": userData["id"] ?? 0,
          "id": userData["id"] ?? 0,
          "username": userData["username"] ?? '',
          "first_name": userData["first_name"] ?? '',
          "last_name": userData["last_name"] ?? '',
          "fullName":
              "${userData["first_name"] ?? ''} ${userData["last_name"] ?? ''}",
          "email": userData["email"] ?? '',
          "phone": userData["phone"] ?? '',
          "gender": userData["gender"] ?? '',
          "role": (userData["roles"] != null && userData["roles"].isNotEmpty)
              ? userData["roles"][0]['name'] ?? ''
              : '',
          "roleId": roleId.toString(),
          "token": userData["bearer_token"] ?? '',
          "image": imagePath ?? '',
          "supplierKey": supplierKey,
          "userPermissions": userPermissions
        };
        String jsonString = jsonEncode(user);
        await prefs.setString('user', jsonString);
        isLoading.value = false;
        Get.toNamed(AppRoutes.dashboard);
        ToastHelper.showToast(context,
            message: "Login Successful",
            backgroundColor: ColorSchema.success.withOpacity(0.7));
        notFound.value = false;
        return true; // Return true if login is successful
      } else {
        isLoading.value = false;
        ToastHelper.showToast(context,
            message: "Login Failed",
            backgroundColor: ColorSchema.danger.withOpacity(0.7));
        return false; // Return false if login fails
      }
    } catch (e) {
      isLoading.value = false;
      ToastHelper.showToast(context,
          message: "Invalid username or password",
          backgroundColor: ColorSchema.danger.withOpacity(0.7));
      return false; // Return false if an error occurs
    }
  }

  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove('user');
  }
}

class UserController extends GetxController {
  RxMap<String, dynamic> user = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user');
    if (jsonString != null) {
      user.value = jsonDecode(jsonString);
    }
  }

  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove('user');
  }
}
