import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/presentation/screens/purchase/purchase_main_screen.dart';
import 'package:inventual/src/utils/contstants.dart';

class CreatePurchaseController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxDouble totalSubtotals = 0.0.obs;
  final RxDouble totalTax = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt supplierID = 0.obs;
  final RxString supplierValue = ''.obs;
  final RxInt purchaseStatusID = 0.obs;
  final RxInt productQuantity = 0.obs;
  final RxString purchaseStatusValue = ''.obs;
  final Rx<TextEditingController> amount = TextEditingController().obs;
  final Rx<TextEditingController> shippingAmount = TextEditingController().obs;
  final Rx<TextEditingController> date = TextEditingController().obs;
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
      double price = double.parse(product[i]['price']);
      double productTax = 0;
      double productDiscount = 0;

      // Assuming flat tax and discount values
      double productTaxValue = double.parse(product[i]["tax"] ?? "0");
      productTax = productTaxValue;

      double productDiscountValue = double.parse(product[i]["discount"] ?? "0");
      productDiscount = productDiscountValue;

      // Calculate subtotal for this product
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
    totalAmount.value = totalSubtotal + shippingAmountInt;
    amount.value.text = totalAmount.value.toString();
  }

  Future createPurchase(
      {required List<dynamic> product, required dynamic userId}) async {
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
      final supplierIDValue = supplierID.value.toString();
      final totalTaxValue = totalTax.value.toString();
      final totalDiscountValue = totalDiscount.value.toString();
      final calculateTotal = totalAmount.value + shippingAmountInt;
      final totalAmountValue = calculateTotal.toString();
      final wareHouseIDValue = wareHouseID.value.toString();
      final purchaseStatus = purchaseStatusValue.value;
      final jsonEndodeProduct = jsonEncode(product);
      final amountValue = amount.value.text;
      final String defaultDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final finalDate =
          date.value.text == '' ? defaultDate.toString() : date.value.text;
      Map<dynamic, dynamic> requestBody = {
        "userId": userIdValue,
        "supplierId": supplierIDValue,
        "warehouseId": wareHouseIDValue,
        "products": jsonEndodeProduct,
        "amount": amountValue,
        "taxAmount": totalTaxValue,
        "discount": totalDiscountValue,
        "totalAmount": totalAmountValue,
        "shippingAmount": shippingAmountInt.toString(),
        "PurchaseDateAt": finalDate,
        "purchaseStatus": purchaseStatus,
      };

      const url = "${AppStrings.baseUrlV1}purchases/save";
      final jsonResponse = await _apiServices.postApiV2(requestBody, url);
      if (jsonResponse != null) {
        supplierID.value = 0;
        wareHouseID.value = 0;
        purchaseStatusID.value = 0;
        amount.value.text = '';
        totalTax.value = 0;
        totalDiscount.value = 0;
        totalAmount.value = 0;
        Get.snackbar(
          "Success",
          "Purchase Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );

        Get.off(const PurchaseMainScreen());
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Fail Create Purchase",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}

class PurchaseController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxList<Map<String, dynamic>> purchasesList =
      <Map<String, dynamic>>[].obs;

  void fetchAllPurchaseListData() async {
    isLoading.value = true;
    await fetchAllPurchases();
    isLoading.value = false;
  }

  Future<void> fetchAllPurchases() async {
    try {
      isLoading.value = true;
      const url = "${AppStrings.baseUrlV1}purchases/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        purchasesList.clear();
        purchasesList.addAll(data.map((item) {
          String purchaseDateAt = item["purchase_date_at"] ?? '';
          String formattedDate = '';

          if (purchaseDateAt.isNotEmpty) {
            try {
              final DateTime parsedDate = DateTime.parse(purchaseDateAt);
              formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = purchaseDateAt;
            }
          }

          return {
            "id": item["id"]?.toString() ?? '',
            "purchase_date_at": formattedDate,
            "supplier": item["supplier"]['first_name'] ?? 'No supplier Found',
            "warehouse": item["warehouse"]['name'] ?? 'No warehouse Found',
            "purchase_status": item["purchase_status"] ?? '',
            "total_amount": item["total_amount"] ?? '',
            "discount_amount": item["discount_amount"] ?? '',
            "shipping_amount": item["shipping_amount"] ?? '',
            "tax_amount": item["tax_amount"] ?? '',
            "amount": item["amount"] ?? '',
          };
        }).toList());
        purchasesList.refresh();
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
