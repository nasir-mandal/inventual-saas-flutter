import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';

class WarehouseReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;

  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxInt reportID = 0.obs;
  final RxString reportValue = ''.obs;
  final RxList<Map<String, dynamic>> warehouseReport =
      <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllWarehouseReport() async {
    try {
      final reportType = reportValue.value == '' ? '' : reportValue.value;

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
          "${await AppStrings.getBaseUrlV1()}report/warehouse?from_date=$formattedStartDate&to_date=$formattedEndDate&report_type=$reportType";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        warehouseReport.clear();
        warehouseReport.addAll(data.map((item) {
          return {
            "name": item["name"] ?? '',
            "phone": item["phone"] ?? '',
            "email": item["email"] ?? '',
            "address": item["address"] ?? '',
          };
        }).toList());

        return warehouseReport;
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
