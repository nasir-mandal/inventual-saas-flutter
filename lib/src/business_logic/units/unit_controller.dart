import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/presentation/screens/unit/unit_management_main_screen.dart';
import 'package:inventual/src/utils/contstants.dart';

class UnitController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = true.obs;
  final Rx<TextEditingController> name = TextEditingController().obs;
  final Rx<TextEditingController> unitType = TextEditingController().obs;

  Future<bool> deleteUnits(int id) async {
    try {
      final changeIdType = id.toString();
      deleteLoading.value = true;
      final url = "${AppStrings.baseUrlV1}units/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);
      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Units deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }

  Future<bool> createUnit() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> requestBody = {
        "name": name.value.text,
        "unit_type": unitType.value.text,
      };
      const url = "${AppStrings.baseUrlV1}units/save";
      final jsonResponse = await _apiServices.postApiV2(requestBody, url);
      if (jsonResponse != null) {
        isLoading.value = false;
        name.value.text = '';
        unitType.value.text = '';
        Get.snackbar(
          "Success",
          "Unit Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unit Created Fail",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
      return false;
    }
  }

  Future<void> updateUnit(dynamic unitObj) async {
    isLoading.value = true;

    try {
      Map<String, dynamic> requestBody = {
        "name": name.value.text == '' ? unitObj['name'] : name.value.text,
        "unit_type": unitType.value.text == ''
            ? unitObj['unit_type']
            : unitType.value.text,
        "_method": "PUT"
      };
      final url = "${AppStrings.baseUrlV1}units/update/${unitObj['id']}";
      final jsonResponse = await _apiServices.postApiV2(requestBody, url);
      if (jsonResponse != null) {
        isLoading.value = false;
        name.value.text = '';
        unitType.value.text = '';
        Get.off(const UnitManagementMainScreen());
        Get.snackbar(
          "Success",
          "Unit Update Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Unit Update Fail",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }
}
