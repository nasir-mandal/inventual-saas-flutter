import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class DiscountReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;

  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxList<Map<String, dynamic>> discountReport =
      <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllDiscountReport() async {
    try {
      final startDateStr = fromDate.value.text;
      final endDateStr = toDate.value.text;

      final DateFormat inputFormat = DateFormat('M/d/yyyy');
      final DateFormat outputFormat = DateFormat('yyyy-MM-dd');

      final String formattedStartDate = startDateStr.isNotEmpty
          ? outputFormat.format(inputFormat.parse(startDateStr))
          : '';
      final String formattedEndDate = endDateStr.isNotEmpty
          ? outputFormat.format(inputFormat.parse(endDateStr))
          : '';

      isLoading.value = true;
      final url =
          "${await AppStrings.getBaseUrlV1()}report/discount?from_date=$formattedStartDate&to_date=$formattedEndDate";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        discountReport.clear();
        discountReport.addAll(data.map((item) {
          return {
            "sale_date": item["sale_date"] ?? '',
            "warehouse_name": item["warehouse_name"] ?? '',
            "product_name": item["product_name"] ?? '',
            "invoice_no": item["invoice_no"] ?? 0,
            "discount_type": item["discount_type"] ?? '',
            "discount": item["discount"] ?? '',
          };
        }).toList());

        return discountReport;
      } else {
        isLoading.value = false;
        return [];
      }
    } catch (e) {
      isLoading.value = false;

      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
