import 'package:get/get.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CountryController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxList<Map<String, dynamic>> countryList = <Map<String, dynamic>>[].obs;

  Future<void> fetchAllCountry() async {
    try {
      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}country/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        countryList.clear();
        countryList.addAll(data
            .map((item) => {
                  "id": item["id"] as int? ?? 0,
                  "title": item["title"] ?? '',
                })
            .toList());
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
