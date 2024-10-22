import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/presentation/screens/pos_sales/pos_sales_sections/pay_complete_section.dart';
import 'package:inventual/src/utils/contstants.dart';

class CreatePaymentController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxDouble totalSubtotals = 0.0.obs;
  final RxDouble totalTax = 0.0.obs;
  final RxDouble change = 0.0.obs;
  final RxDouble due = 0.0.obs;
  final RxInt paymentTypeId = 0.obs;
  final RxString paymentTypeValue = ''.obs;
  final Rx<TextEditingController> paidAmount = TextEditingController().obs;
  final Rx<TextEditingController> transactionNumber =
      TextEditingController().obs;
  final Rx<TextEditingController> cardNumber = TextEditingController().obs;
  final Rx<TextEditingController> bkashNumber = TextEditingController().obs;
  final Rx<TextEditingController> remark = TextEditingController().obs;

  double totalSubtotal = 0;

  void calculateSubtotals({
    required double payableAmount,
  }) {
    final double payableDoubleAmount =
        double.tryParse(paidAmount.value.text) ?? 0.0;
    if (payableAmount < payableDoubleAmount) {
      change.value = payableDoubleAmount - payableAmount;
      due.value = 0.0;
    } else {
      due.value = payableAmount - payableDoubleAmount;
      change.value = 0.0;
    }
  }

  Future createPayment({
    required dynamic orderId,
    required double payableAmount,
  }) async {
    isLoading.value = true;
    try {
      final String formattedDate =
          DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());

      final orderIdValue = orderId.toString();
      Map<dynamic, dynamic> requestBody = {
        "orderId": orderIdValue,
        "payableAmount": payableAmount.toString(),
        "paidAmount": paidAmount.value.text,
        "paymentDate": formattedDate,
        "paymentType": paymentTypeValue.value,
        "accountNumber": cardNumber.value.text,
        "trxNumber": transactionNumber.value.text,
        "remark": remark.value.text,
      };

      const url = "${AppStrings.baseUrlV1}payments/save";
      final jsonResponse = await _apiServices.postApiV2(requestBody, url);
      if (jsonResponse != null) {
        Get.to(() => const PayCompleteSection());

        Get.snackbar(
          "Success",
          "Payment Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Fail Create Payment",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}
