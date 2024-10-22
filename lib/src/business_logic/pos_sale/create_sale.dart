import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/presentation/screens/sales/sales_main_screen.dart';
import 'package:inventual/src/utils/contstants.dart';

class CreateSaleController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxDouble totalSubtotals = 0.0.obs;
  final RxDouble totalTax = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt customerID = 0.obs;
  final RxString customerValue = ''.obs;
  final RxInt billerID = 0.obs;
  final RxInt orderID = 0.obs;
  final RxDouble payableAmount = 0.0.obs;
  final RxString billerValue = ''.obs;
  final RxInt saleStatusID = 0.obs;
  final RxString saleStatusValue = ''.obs;
  final RxInt paymentStatusID = 0.obs;
  final RxString paymentStatusValue = ''.obs;
  final Rx<TextEditingController> amount = TextEditingController().obs;
  final Rx<TextEditingController> shippingAmount = TextEditingController().obs;
  final Rx<TextEditingController> returnNote = TextEditingController().obs;
  final Rx<TextEditingController> remark = TextEditingController().obs;
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

      if (product[i]["tax_type"] == "Percent") {
        double productTaxPercent = double.parse(product[i]["tax"]);
        productTax = price * (productTaxPercent / 100);
      } else if (product[i]["tax_type"] == "Fixed") {
        productTax = double.parse(product[i]["tax"]);
      }

      if (product[i]["discount_type"] == "Percent") {
        double productDiscountPercent = double.parse(product[i]["discount"]);
        productDiscount = price * (productDiscountPercent / 100);
      } else if (product[i]["discount_type"] == "Fixed") {
        productDiscount = double.parse(product[i]["discount"]);
      }

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

  Future createSale({
    required List<dynamic> product,
    required dynamic userId,
    required String paymentPage,
  }) async {
    isLoading.value = true;

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

    try {
      int shippingAmountInt = 0;
      if (shippingAmount.value.text.isNotEmpty) {
        shippingAmountInt = int.parse(shippingAmount.value.text);
      }

      final userIdValue = userId.toString();
      final customerIDValue = customerID.value.toString();
      final totalTaxValue = totalTax.value.toString();
      final totalDiscountValue = totalDiscount.value.toString();
      final calculateTotal = totalAmount.value + shippingAmountInt;
      final totalAmountValue = calculateTotal.toString();
      final wareHouseIDValue = wareHouseID.value.toString();
      final billerIDValue = billerID.value.toString();
      final jsonEndodeProduct = jsonEncode(product);
      final amountValue = amount.value.text;
      final String defaultDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final finalDate =
          date.value.text == '' ? defaultDate.toString() : date.value.text;

      Map<dynamic, dynamic> requestBody = {
        "userId": userIdValue,
        "customerId": customerIDValue,
        "warehouseId": wareHouseIDValue,
        "billerId": billerIDValue,
        "products": jsonEndodeProduct,
        "amount": amountValue,
        "taxAmount": totalTaxValue,
        "discount": totalDiscountValue,
        "totalAmount": totalAmountValue,
        "shippingAmount": shippingAmountInt.toString(),
        "saleDateAt": finalDate,
        "paymentStatus": paymentStatusValue.value,
        "saleStatus": saleStatusValue.value,
      };
      const url = "${AppStrings.baseUrlV1}sales/save";
      final jsonResponse = await _apiServices.postApiV2(requestBody, url);
      if (jsonResponse != null) {
        orderID.value = jsonResponse['data']['id'];
        payableAmount.value =
            double.parse(jsonResponse['data']['total_amount']);
        if (paymentPage != "payment") {
          Get.off(const SalesMainScreen());
          Get.snackbar(
            "Success",
            "Sale Created Successfully",
            backgroundColor: ColorSchema.success.withOpacity(0.5),
            colorText: ColorSchema.white,
            animationDuration: const Duration(milliseconds: 800),
          );
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Fail Create Sale",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}
