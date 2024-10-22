import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';

class CustomerReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;

  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt reportID = 0.obs;
  final RxString reportValue = ''.obs;
  final RxList<Map<String, dynamic>> customersReport =
      <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllCustomersReport() async {
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
          "${AppStrings.baseUrlV1}report/customer?from_date=$formattedStartDate&to_date=$formattedEndDate&warehouse_id=$warehouseID";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        customersReport.clear();
        customersReport.addAll(data.map((item) {
          return {
            "sale_date": item["sale_date"] ?? '',
            "customer_name": item["customer_name"] ?? '',
            "customer_phone": item["customer_phone"] ?? '',
            "warehouse_name": item["warehouse_name"] ?? '',
            "products": item["products"] ?? '',
            "total_amount": item["total_amount"] ?? '',
          };
        }).toList());

        return customersReport;
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
