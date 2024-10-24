import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class SupplierReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;

  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxList<Map<String, dynamic>> suppliersReport =
      <Map<String, dynamic>>[].obs;
  Future<List<Map<String, dynamic>>> fetchAllSupplierReport() async {
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
          "${await AppStrings.getBaseUrlV1()}report/supplier?from_date=$formattedStartDate&to_date=$formattedEndDate&warehouse_id=$warehouseID";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        suppliersReport.clear();
        suppliersReport.addAll(data.map((item) {
          return {
            "purchase_date": item["purchase_date"] ?? '',
            "supplier_name": item["supplier_name"] ?? '',
            "supplier_code": item["supplier_code"] ?? '',
            "warehouse_name": item["warehouse_name"] ?? '',
            "products": item["products"] ?? '',
            "total_amount": item["total_amount"] ?? '',
          };
        }).toList());

        return suppliersReport;
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
