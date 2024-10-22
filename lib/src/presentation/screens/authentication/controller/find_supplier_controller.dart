import 'package:get/get.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/presentation/screens/authentication/model/find_supplier_model.dart';
import 'package:inventual/src/utils/contstants.dart';

class FindSupplierController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // District Variable
  final RxBool districtProgress = false.obs;
  final RxString districtName = "".obs;
  final RxInt districtId = 0.obs;
  final List<DistrictData> districtList = <DistrictData>[].obs;

  @override
  onInit() {
    super.onInit();
    getDistrict();
  }

  Future<void> getDistrict() async {
    try {
      districtProgress.value = true;
      final String url = "${AppStrings.baseUrlV2}district/list?country_id=1";
      final response = await _apiServices.getApi(url);
      final responseData = DistrictModel.fromJson(response);
      districtList.addAll(responseData.data!);
    } finally {
      districtProgress.value = false;
    }
  }
}
