import 'package:get/get.dart';
import 'package:inventual/src/network/services/network_api_services.dart';

class FindSupplierController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool districtProgress = false.obs;

  @override
  onInit() {
    super.onInit();
    // getDistrict();
  }

  // Future<void> getDistrict() async {
  //   try {
  //     districtProgress.value = true;
  //     final String url = "${AppStrings.baseUrlV2}district/list?country_id=1";
  //     final jsonResponse = await _apiServices.getApi(url);
  //   } finally {
  //     districtProgress.value = false;
  //   }
  // }
}
