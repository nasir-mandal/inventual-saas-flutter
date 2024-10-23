import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';

class PaymentListController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxList<Map<String, dynamic>> paymentList = <Map<String, dynamic>>[].obs;
  Future<void> fetchAllPaymentList() async {
    try {
      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}payments/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        paymentList.clear();
        paymentList.addAll(data.map((item) {
          String formattedDate = formatDate(item["payment_date"] ?? '');
          return {
            "id": item["id"] as int? ?? 0,
            "order_id": item["order_id"]?.toString() ?? '',
            "payable_amount": item["payable_amount"]?.toString() ?? '',
            "paid_amount": item["paid_amount"]?.toString() ?? '',
            "due_amount": item["due_amount"]?.toString() ?? '',
            "payment_type": item["payment_type"]?.toString() ?? '',
            "account_number": item["account_number"]?.toString() ?? '',
            "trx_number": item["trx_number"]?.toString() ?? '',
            "remark": item["remark"]?.toString() ?? '',
            "date": formattedDate,
          };
        }).toList());
        isLoading.value = false;
      } else {
        isLoading.value = false;
        notFound.value = true;
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  String formatDate(String dateStr) {
    try {
      DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr);
      return DateFormat("d MMMM yyyy, ha").format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }
}
