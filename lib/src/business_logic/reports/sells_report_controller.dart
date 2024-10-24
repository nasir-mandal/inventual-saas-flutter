import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class SalesListController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;
  final RxInt reportID = 0.obs;
  final RxString reportValue = ''.obs;
  final RxList<Map<String, dynamic>> salesList = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllSellsReport() async {
    try {
      final warehouseID = wareHouseID.value == 0 ? '' : wareHouseID.value;
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
          "${await AppStrings.getBaseUrlV1()}report/sale?from_date=$formattedStartDate&to_date=$formattedEndDate&warehouse_id=$warehouseID&report_type=$reportType";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        salesList.clear();
        salesList.addAll(data.map((item) {
          return {
            "id": item["id"] as int? ?? 0,
            "sale_date": item["sale_date"] ?? '',
            "warehouse_name": item["warehouse_name"] ?? '',
            "product_name": item["product_name"] ?? '',
            "product_code": item["product_code"] ?? '',
            "unit": item["unit"] ?? '',
            "product_stock": item["product_stock"] ?? 0,
            "quantity": item["quantity"] ?? 0,
            "sale_amount": item["sale_amount"].toString(),
          };
        }).toList());

        return salesList;
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
