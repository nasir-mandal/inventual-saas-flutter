import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSupplierController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = false.obs;
  final RxBool deleteSuccess = false.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();

  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> country = TextEditingController().obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final Rx<TextEditingController> supplierCode = TextEditingController().obs;
  final RxInt companyID = 0.obs;
  final RxString companyValue = ''.obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;
  void createSupplier() async {
    await _createSupplier();
  }

  Future<bool> deleteSupplierList(int id) async {
    try {
      final changeIdType = id.toString();
      deleteLoading.value = true;
      final url = "${AppStrings.baseUrlV1}suppliers/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);
      if (jsonResponse != null && jsonResponse["success"] == true) {
        deleteSuccess.value = true;
        Get.snackbar(
          "Success",
          "Suppliers deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the suppliers",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }

  Future _createSupplier() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    try {
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        Map<String, dynamic> requestBody = {
          "userId": userMap['user_id'].toString(),
          "countryId": countryID.value,
          "companyId": companyID.value,
          "firstName": firstName.value.text,
          "lastName": lastName.value.text,
          "phone": phone.value.text,
          "email": email.value.text,
          "city": city.value.text,
          "address": address.value.text,
          "supplierCode": supplierCode.value.text,
          "zipCode": zipCode.value.text,
        };
        const url = "${AppStrings.baseUrlV1}suppliers/save";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null) {
          firstName.value.text = '';
          lastName.value.text = '';
          email.value.text = '';
          phone.value.text = '';
          countryID.value = 0;
          countryValue.value = '';
          city.value.text = '';
          zipCode.value.text = '';
          supplierCode.value.text = '';
          address.value.text = '';
          isLoading.value = false;
          Get.back();

          Get.snackbar(
            "Success",
            "Supplier Added Successfully",
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
        "Fail Create Product",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}

class UpdateSupplierController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = true.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();
  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> country = TextEditingController().obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final Rx<TextEditingController> supplierCode = TextEditingController().obs;
  final RxInt companyID = 0.obs;
  final RxString companyValue = ''.obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;

  void updateSupplier(dynamic supplier) async {
    isLoading.value = true;
    await _updateSupplier(supplierObj: supplier);
    isLoading.value = false;
  }

  Future _updateSupplier({required dynamic supplierObj}) async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    try {
      if (userString != null) {
        Map<String, dynamic> requestBody = {
          "countryId": countryID.value == 0
              ? supplierObj['country_id']
              : countryID.value,
          "companyId": companyID.value == 0
              ? supplierObj['company_id']
              : companyID.value,
          "firstName": firstName.value.text == ''
              ? supplierObj['first_name']
              : firstName.value.text,
          "lastName": lastName.value.text == ''
              ? supplierObj['last_name']
              : lastName.value.text,
          "phone":
              phone.value.text == '' ? supplierObj['phone'] : phone.value.text,
          "email":
              email.value.text == '' ? supplierObj['email'] : email.value.text,
          "city": city.value.text == '' ? supplierObj['city'] : city.value.text,
          "address": address.value.text == ''
              ? supplierObj['address']
              : address.value.text,
          "supplierCode": supplierCode.value.text == ''
              ? supplierObj['supplier_code']
              : supplierCode.value.text,
          "zipCode": zipCode.value.text == ''
              ? supplierObj['zip_code']
              : supplierCode.value.text,
          "_method": "PUT",
        };

        final url =
            "${AppStrings.baseUrlV1}suppliers/update/${supplierObj['id']}";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null) {
          firstName.value.text = '';
          lastName.value.text = '';
          email.value.text = '';
          phone.value.text = '';
          city.value.text = '';
          zipCode.value.text = '';
          supplierCode.value.text = '';
          address.value.text = '';
          isLoading.value = false;
          Get.back();
          Get.snackbar(
            "Success",
            "Supplier update successfully",
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
      isLoading.value = false;
      Get.snackbar(
        "Failed",
        "update Failed",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
    }
  }
}
