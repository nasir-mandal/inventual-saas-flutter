import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/presentation/screens/authentication/model/find_supplier_model.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindSupplierController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Verify Progress
  final RxBool verifyProgress = false.obs;

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
  final RxString supplierKey = "".obs;
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
      final String url =
          "${AppStrings.defaultBaseUrlV1}district/list?country_id=1";
      final response = await _apiServices.getApiBeforeAuthentication(url);
      final responseData = DistrictModel.fromJson(response);
      districtList.clear();
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
          "${AppStrings.defaultBaseUrlV1}area/list?district_id=$districtId";
      final response = await _apiServices.getApiBeforeAuthentication(url);
      final responseData = AreaModel.fromJson(response);
      areaList.clear();
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
          "${AppStrings.defaultBaseUrlV1}suppliers/stores?area_id=$areaId";
      final response = await _apiServices.getApiBeforeAuthentication(url);
      final responseData = SupplierModel.fromJson(response);
      supplierList.clear();
      supplierList.addAll(responseData.data!);
    } finally {
      supplierProgress.value = false;
    }
  }

  // Supplier Function End
  // ------------------------------------------------------------------------ //

  // ------------------------------------------------------------------------ //
  // Verify Function Start
  Future<void> supplierVerify() async {
    if (districtName.isEmpty && districtId.value <= 0) {
      Fluttertoast.showToast(
          msg: "Please select a District before proceeding.",
          backgroundColor: ColorSchema.danger,
          textColor: ColorSchema.white);
    } else if (areaName.isEmpty && areaId.value <= 0) {
      Fluttertoast.showToast(
          msg: "Please select a Area before proceeding.",
          backgroundColor: ColorSchema.danger,
          textColor: ColorSchema.white);
    } else if (supplierName.isEmpty &&
        supplierId.value <= 0 &&
        supplierKey.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please select a Supplier before proceeding.",
          backgroundColor: ColorSchema.danger,
          textColor: ColorSchema.white);
    } else {
      verifyProgress.value = true;
      Future.delayed(Duration(seconds: 1), () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('supplier_key', supplierKey.toString());
        Get.offNamed(AppRoutes.login);
        clearFilteredValue();
        verifyProgress.value = true;
      });
    }
  }
  // Verify Function End
  // ------------------------------------------------------------------------ //

  // ------------------------------------------------------------------------ //
  // Clear Filtered Value Function Start
  void clearFilteredValue() {
    districtName.value = "";
    districtId.value;
    0;
    areaName.value = "";
    areaId.value = 0;
    supplierName.value = "";
    supplierId.value = 0;
    supplierKey.value = "";
  }
  // Clear Filtered Value Function End
  // ------------------------------------------------------------------------ //
}
