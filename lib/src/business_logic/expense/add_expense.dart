import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/presentation/screens/expense_list/expense_list_main_screen.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenseController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool allCategoryLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt wareHouseID = 0.obs;
  final RxString supplierValue = ''.obs;
  final RxInt supplierID = 0.obs;
  final RxString categoryValue = ''.obs;
  final RxInt categoryID = 0.obs;
  final RxString expenseTypeValue = ''.obs;
  final RxInt expenseID = 0.obs;
  final Rx<TextEditingController> amount = TextEditingController().obs;
  final Rx<TextEditingController> voucherNo = TextEditingController().obs;
  final Rx<TextEditingController> notes = TextEditingController().obs;
  final Rx<TextEditingController> date = TextEditingController().obs;

  void createExpense() async {
    isLoading.value = true;
    await _createExpense();
    isLoading.value = false;
  }

  Future _createExpense() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userString = prefs.getString("user");
      final String defaultDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final finalDate =
          date.value.text == '' ? defaultDate.toString() : date.value.text;
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        Map<String, dynamic> requestBody = {
          "userId": userMap['user_id'].toString(),
          "warehouseId": wareHouseID.value,
          "supplierId": supplierID.value,
          "categoryId": categoryID.value,
          "amount": amount.value.text,
          "expenseDateAt": finalDate,
          "voucherNo": voucherNo.value.text,
          "expenseType": expenseTypeValue.value,
          "comment": notes.value.text
        };
        final url = "${await AppStrings.getBaseUrlV1()}expenses/save";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null) {
          amount.value.text = '';
          voucherNo.value.text = '';
          notes.value.text = '';
          notFound.value = false;
          isLoading.value = false;
          Get.snackbar(
            "Success",
            "Expense Added Successfully",
            backgroundColor: ColorSchema.success.withOpacity(0.5),
            colorText: ColorSchema.white,
            animationDuration: const Duration(milliseconds: 800),
          );
          Get.off(() => const ExpenseListMainScreen());
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }
}
