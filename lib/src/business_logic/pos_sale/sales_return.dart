import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/presentation/screens/sales/salesSections/sales_return_section.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSalesReturnController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxDouble totalSubtotals = 0.0.obs;
  final RxDouble totalTax = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt billerID = 0.obs;
  final RxString billerValue = ''.obs;
  final RxInt customerID = 0.obs;
  final RxString customerIDValue = ''.obs;
  final RxInt returnStatusID = 0.obs;
  final RxInt productQuantity = 0.obs;
  final RxString returnStatusValue = ''.obs;
  final Rx<TextEditingController> amount = TextEditingController().obs;
  final Rx<TextEditingController> shippingAmount = TextEditingController().obs;
  final Rx<TextEditingController> date = TextEditingController().obs;
  final Rx<TextEditingController> returnNote = TextEditingController().obs;
  final Rx<TextEditingController> remark = TextEditingController().obs;
  double totalSubtotal = 0;

  void calculateSubtotals({
    required List<dynamic> product,
    required List<dynamic> quantities,
    required List<dynamic> subtotals,
  }) {
    double totalSubtotal = 0;
    double totalTaxValue = 0;
    double totalDiscountValue = 0;

    for (int i = 0; i < product.length; i++) {
      double productTaxPercent = double.parse(product[i]["tax"]);
      double productDiscountPercent = double.parse(product[i]["discount"]);
      double price = double.parse(product[i]['price']);

      double productTax = price * (productTaxPercent / 100);
      double productDiscount = price * (productDiscountPercent / 100);

      double subtotal = (price + productTax - productDiscount) * quantities[i];
      subtotals[i] = subtotal;
      totalSubtotal += subtotal;
      totalTaxValue += productTax * quantities[i];
      totalDiscountValue += productDiscount * quantities[i];
    }
    int shippingAmountInt = 0;
    if (shippingAmount.value.text.isNotEmpty) {
      shippingAmountInt = int.parse(shippingAmount.value.text);
    }

    totalSubtotals.value = totalSubtotal + shippingAmountInt;

    totalTax.value = double.parse(totalTaxValue.toStringAsFixed(2));
    totalDiscount.value = totalDiscountValue;
    totalAmount.value = totalSubtotal;
    amount.value.text = totalAmount.value.toString();
  }

  Future createSalesReturn({
    required List<dynamic> product,
    required dynamic userId,
  }) async {
    if (product.isEmpty) {
      Get.snackbar(
        "Error",
        "No products found. Please add at least one product.",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      return;
    }

    isLoading.value = true;
    try {
      int shippingAmountInt = 0;
      if (shippingAmount.value.text.isNotEmpty) {
        shippingAmountInt = int.parse(shippingAmount.value.text);
      }
      final userIdValue = userId.toString();
      final totalTaxValue = totalTax.value.toString();
      final billerIDValue = billerID.value.toString();
      final customerIDValue = customerID.value.toString();
      final totalDiscountValue = totalDiscount.value.toString();
      final calculateTotal = totalAmount.value + shippingAmountInt;
      final totalAmountValue = calculateTotal.toString();
      final wareHouseIDValue = wareHouseID.value.toString();
      final returnStatus = returnStatusValue.value;
      final jsonEndodeProduct = jsonEncode(product);
      final amountValue = amount.value.text;
      final String defaultDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final finalDate =
          date.value.text == '' ? defaultDate.toString() : date.value.text;
      Map<dynamic, dynamic> requestBody = {
        "userId": userIdValue,
        "warehouseId": wareHouseIDValue,
        "products": jsonEndodeProduct,
        "billerId": billerIDValue,
        "customerId": customerIDValue,
        "amount": amountValue,
        "taxAmount": totalTaxValue,
        "discount": totalDiscountValue,
        "totalAmount": totalAmountValue,
        "shippingAmount": shippingAmountInt.toString(),
        "refund_date_at": finalDate,
        "refund_status": returnStatus,
        "remark": remark.value.text,
        "refund_note": returnNote.value.text,
      };
      final url = "${await AppStrings.getBaseUrlV1()}sales/return/save";
      final jsonResponse = await _apiServices.postApiV2(requestBody, url);

      if (jsonResponse != null) {
        wareHouseID.value = 0;
        billerID.value = 0;
        customerID.value = 0;
        returnStatusID.value = 0;
        amount.value.text = '';
        totalTax.value = 0;
        totalDiscount.value = 0;
        totalAmount.value = 0;
        Get.snackbar(
          "Success",
          "Sales Return Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );

        Get.off(const SalesReturnSection());
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Fail Return Purchase",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}

class SalesReturnController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxBool deleteLoading = false.obs;
  final RxList<Map<String, dynamic>> salesReturnList =
      <Map<String, dynamic>>[].obs;

  Future<void> fetchAllReturnSales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString('settings') ?? '';

      String currencySymbol = '';
      if (settingsString.isNotEmpty) {
        final settings = jsonDecode(settingsString);
        currencySymbol = settings['currency_symbol'] ?? '\$';
      }

      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}sales/return/list";

      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse == null || jsonResponse["data"] == null) {
        isLoading.value = false;
        return;
      }
      final List data = jsonResponse["data"];
      salesReturnList.clear();
      for (var item in data) {
        salesReturnList.add({
          "id": item["id"]?.toString() ?? '',
          "refund_date_at": _formatDate(item["refund_date_at"]),
          "customer": _getFullName(item["customer"], 'No Customer Found'),
          "warehouse": item["warehouse"]?['name'] ?? 'No warehouse Found',
          "biller": _getFullName(item["biller"], 'No biller Found'),
          "refund_status": item["refund_status"] ?? '',
          "total_amount": item["total_amount"] ?? '',
          "discount": item["discount"] ?? '',
          "remark": item["remark"] ?? '',
          "shipping_amount": item["shipping_amount"] ?? '',
          "tax_amount": item["tax_amount"] ?? '',
          "amount": item["amount"] ?? '',
          "currencySymbol": currencySymbol,
        });
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _getFullName(Map<String, dynamic>? person, String defaultValue) {
    if (person == null) return defaultValue;
    final firstName = person['first_name'] ?? '';
    final lastName = person['last_name'] ?? '';
    return firstName.isEmpty && lastName.isEmpty
        ? defaultValue
        : "$firstName $lastName";
  }

  Future<bool> deleteSalesReturn(id) async {
    try {
      deleteLoading.value = true;

      final String changeIdType = id.toString();
      final String url =
          "${await AppStrings.getBaseUrlV1()}sales/return/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Sales Return deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the Sales Return",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while deleting the Sales Return",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }
}
