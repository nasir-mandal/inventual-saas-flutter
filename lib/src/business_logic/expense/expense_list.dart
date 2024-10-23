import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';

class ExpenseListController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxBool deleteLoading = false.obs;
  final RxList<Map<String, dynamic>> expenseList = <Map<String, dynamic>>[].obs;
  Future<void> fetchExpenseReport() async {
    try {
      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}expenses/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        expenseList.clear();
        expenseList.addAll(data.map((item) {
          String purchaseDateAt = item["expense_date_at"] ?? '';
          String formattedDate = '';
          if (purchaseDateAt.isNotEmpty) {
            try {
              final DateTime parsedDate = DateTime.parse(purchaseDateAt);
              formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = purchaseDateAt;
            }
          }
          return {
            "id": item["id"] as int? ?? 0,
            "amount": item["amount"] ?? '',
            "expense_date_at": formattedDate,
            "voucher_no": item["voucher_no"] ?? '',
            "expense_type": item["expense_type"] ?? '',
            "comment": item["comment"] ?? '',
            "status": item["status"] ?? '',
          };
        }).toList());
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteExpense(dynamic id) async {
    try {
      deleteLoading.value = true;
      final String changeIdType = id.toString();
      final String url =
          "${await AppStrings.getBaseUrlV1()}expenses/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);
      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while deleting",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }
}
