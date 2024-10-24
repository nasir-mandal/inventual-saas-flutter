import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class ProductReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxList<Map<String, dynamic>> productsReport =
      <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllProductReport() async {
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
          "${await AppStrings.getBaseUrlV1()}report/product?start_date=$formattedStartDate&end_date=$formattedEndDate";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        productsReport.clear();
        productsReport.addAll(data.map((item) {
          return {
            "date": item["date"] ?? '',
            "warehouse_name": item["warehouse_name"] ?? '',
            "product_name": item["product_name"] ?? '',
            "available_stock": item["available_stock"] ?? 0,
            "price": item["price"] ?? '',
            "sale_quantity": item["sale_quantity"] ?? 0,
            "sale_amount": item["sale_amount"] ?? 0,
            "purchase_quantity": item["purchase_quantity"] ?? 0,
            "purchase_amount": item["purchase_amount"] ?? 0,
          };
        }).toList());

        return productsReport;
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
