import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateWarehouseController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = false.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();
  final Rx<TextEditingController> name = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final Rx<TextEditingController> description = TextEditingController().obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;
  void createWarehouse() async {
    await _createWarehouse();
  }

  Future _createWarehouse() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    try {
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        Map<String, dynamic> requestBody = {
          "userId": userMap['user_id'].toString(),
          "countryId": countryID.value,
          "name": name.value.text,
          "phone": phone.value.text,
          "email": email.value.text,
          "city": city.value.text,
          "zipCode": zipCode.value.text,
          "address": address.value.text,
          "description": description.value.text,
        };
        final url = "${await AppStrings.getBaseUrlV1()}warehouses/save";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null) {
          name.value.text = '';
          email.value.text = '';
          phone.value.text = '';
          countryID.value = 0;
          countryValue.value = '';
          city.value.text = '';
          zipCode.value.text = '';
          address.value.text = '';
          description.value.text = '';
          isLoading.value = false;
          Get.back();
          Get.snackbar(
            "Success",
            "Warehouse Added Successfully",
            backgroundColor: ColorSchema.success.withOpacity(0.5),
            colorText: ColorSchema.white,
            animationDuration: const Duration(milliseconds: 800),
          );
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Fail Create Warehouse",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }

  Future<bool> deleteWarehouse(int id) async {
    try {
      deleteLoading.value = true;

      final String changeIdType = id.toString();
      final String url =
          "${await AppStrings.getBaseUrlV1()}warehouses/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Warehouse deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the Warehouse",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
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

class UpdateWarehouseController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = false.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();
  final Rx<TextEditingController> name = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final Rx<TextEditingController> description = TextEditingController().obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;

  void updateWarehouse(dynamic warehouse) async {
    isLoading.value = true;
    await _updateWarehouse(warehouseObj: warehouse);
    isLoading.value = false;
  }

  Future _updateWarehouse({required dynamic warehouseObj}) async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    try {
      if (userString != null) {
        Map<String, dynamic> requestBody = {
          "countryId": countryID.value == 0
              ? warehouseObj['country_id']
              : countryID.value,
          "name":
              name.value.text == '' ? warehouseObj['title'] : name.value.text,
          "phone":
              phone.value.text == '' ? warehouseObj['phone'] : phone.value.text,
          "email":
              email.value.text == '' ? warehouseObj['email'] : email.value.text,
          "city":
              city.value.text == '' ? warehouseObj['city'] : city.value.text,
          "zipCode": zipCode.value.text == ''
              ? warehouseObj['zip_code']
              : zipCode.value.text,
          "address": address.value.text == ''
              ? warehouseObj['address']
              : address.value.text,
          "description": description.value.text == ''
              ? warehouseObj['description']
              : description.value.text,
          "_method": 'PUT'
        };
        final url =
            "${await AppStrings.getBaseUrlV1()}warehouses/update/${warehouseObj['id']}";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null) {
          name.value.text = '';
          email.value.text = '';
          phone.value.text = '';
          countryValue.value = '';
          city.value.text = '';
          zipCode.value.text = '';
          address.value.text = '';
          description.value.text = '';
          isLoading.value = false;
          Get.snackbar(
            "Success",
            "Warehouse Update Successfully",
            backgroundColor: ColorSchema.success.withOpacity(0.5),
            colorText: ColorSchema.white,
            animationDuration: const Duration(milliseconds: 800),
          );
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Fail Update Warehouse",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}
