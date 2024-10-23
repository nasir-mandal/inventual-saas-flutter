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

  // Area Variable
  final RxBool areaProgress = false.obs;
  final RxString areaName = "".obs;
  final RxInt areaId = 0.obs;
  final List<AreaData> areaList = <AreaData>[].obs;

  // Area Variable
  final RxBool supplierProgress = false.obs;
  final RxString supplierName = "".obs;
  final RxInt supplierId = 0.obs;
  final List<SupplierData> supplierList = <SupplierData>[].obs;

  @override
  onInit() {
    super.onInit();
    getDistrict();
  }

  // ------------------------------------------------------------------------ //
  // District Function Start
  Future<void> getDistrict() async {
    try {
      districtProgress.value = true;
      final String url = "${AppStrings.baseUrlV2}district/list?country_id=1";
      final response = await _apiServices.getApiBeforeAuthentication(url);
      final responseData = DistrictModel.fromJson(response);
      districtList.addAll(responseData.data!);
    } finally {
      districtProgress.value = false;
    }
  }
  // District Function End
  // ------------------------------------------------------------------------ //

  // ------------------------------------------------------------------------ //
  // Area Function Start
  Future<void> getArea() async {
    try {
      areaProgress.value = true;
      final String url =
          "${AppStrings.baseUrlV2}area/list?district_id=$districtId";
      final response = await _apiServices.getApiBeforeAuthentication(url);
      final responseData = AreaModel.fromJson(response);
      areaList.addAll(responseData.data!);
    } finally {
      areaProgress.value = false;
    }
  }
  // Area Function End
  // ------------------------------------------------------------------------ //

// ------------------------------------------------------------------------ //
  // Supplier Function Start
  Future<void> getSupplier() async {
    try {
      supplierProgress.value = true;
      final String url =
          "${AppStrings.baseUrlV2}suppliers/stores?area_id=$areaId";
      final response = await _apiServices.getApiBeforeAuthentication(url);
      final responseData = SupplierModel.fromJson(response);
      supplierList.addAll(responseData.data!);
    } finally {
      supplierProgress.value = false;
    }
  }
  // Supplier Function End
  // ------------------------------------------------------------------------ //
}
