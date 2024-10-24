import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UsersReportReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;

  final Rx<TextEditingController> fromDate = TextEditingController().obs;
  final Rx<TextEditingController> toDate = TextEditingController().obs;
  final RxList<Map<String, dynamic>> usersReport = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> fetchAllUsersReport() async {
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
          "${await AppStrings.getBaseUrlV1()}report/user?from_date=$formattedStartDate&to_date=$formattedEndDate";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        usersReport.clear();
        usersReport.addAll(data.map((item) {
          return {
            "name": item["name"] ?? '',
            "phone": item["phone"] ?? '',
            "email": item["email"] ?? '',
          };
        }).toList());

        return usersReport;
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
