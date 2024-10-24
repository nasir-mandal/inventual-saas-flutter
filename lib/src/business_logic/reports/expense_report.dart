import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class ExpensesReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;

  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt reportID = 0.obs;
  final RxString reportValue = ''.obs;
  final RxList<Map<String, dynamic>> expensesReport =
      <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllExpenseReport() async {
    try {
      final warehouseID = wareHouseID.value == 0 ? '' : wareHouseID.value;

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
          "${await AppStrings.getBaseUrlV1()}report/expense?start_date=$formattedStartDate&end_date=$formattedEndDate&warehouse_id=$warehouseID";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        expensesReport.clear();
        expensesReport.addAll(data.map((item) {
          return {
            "expense_date": item["expense_date"] ?? '',
            "warehouse_name": item["warhouse_name"] ?? '',
            "category_name": item["category_name"] ?? '',
            "expense_type": item["expense_type"] ?? '',
            "amount": item["amount"] ?? '',
          };
        }).toList());

        return expensesReport;
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
