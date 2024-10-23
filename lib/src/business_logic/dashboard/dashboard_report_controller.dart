import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';

class DashboardReportController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxMap<String, dynamic> reportData = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> profitLossDataReport = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> stockDataReport = <String, dynamic>{}.obs;
  final NumberFormat _formatter = NumberFormat('#,##0.00');
  Future<void> fetchDashboardReport() async {
    try {
      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}report/dashboard";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse["success"] == true) {
        final totalAmounts = jsonResponse["data"]["totalAmounts"];
        final profitLossData = jsonResponse["data"]["profitLossData"];
        final stockData = jsonResponse["data"]["stockData"];

        // Parsing totalAmounts data
        final double totalOrder = (totalAmounts["totalOrder"] ?? 0).toDouble();
        final double totalReturnOrder =
            (totalAmounts["totalReturnOrder"] ?? 0).toDouble();
        final double totalPurchase =
            (totalAmounts["totalPurchase"] ?? 0).toDouble();
        final double totalReturnPurchase =
            (totalAmounts["totalReturnPurchase"] ?? 0).toDouble();
        final double totalExpense =
            (totalAmounts["totalExpense"] ?? 0).toDouble();
        final double sales = totalOrder - totalReturnOrder;
        final double purchase = totalPurchase - totalReturnPurchase;
        final double expense = totalExpense;
        final double profit = sales - expense;

        // Updating reportData map
        reportData.value = {
          "sales": _formatter.format(sales),
          "purchase": _formatter.format(purchase),
          "expense": _formatter.format(expense),
          "profit": _formatter.format(profit),
          "totalOrder": _formatter.format(totalOrder),
          "totalReturnOrder": _formatter.format(totalReturnOrder),
          "totalPurchase": _formatter.format(totalPurchase),
          "totalReturnPurchase": _formatter.format(totalReturnPurchase),
          "countWarehouse":
              _formatter.format(totalAmounts["countWarehouse"] ?? 0),
        };

        // Updating profitLossDataReport map
        profitLossDataReport.value = {
          "profit": profitLossData["profit"],
          "loss": profitLossData["loss"],
          "months": profitLossData["months"],
        };

        // Updating stockDataReport map
        stockDataReport.value = {
          "years": stockData["years"],
          "stock": stockData["stock"],
          "quantity": stockData["quantity"],
        };

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
}
