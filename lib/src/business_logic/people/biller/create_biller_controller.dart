import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBillerController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = true.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();
  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> date = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final Rx<TextEditingController> billerCode = TextEditingController().obs;
  final Rx<TextEditingController> nidOrPassportNumber =
      TextEditingController().obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;

  void createBiller() async {
    await _createBiller();
  }

  Future<bool> deleteBiller(int id) async {
    try {
      deleteLoading.value = true;
      final String changeIdType = id.toString();
      final String url = "${AppStrings.baseUrlV1}billers/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);
      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Biller deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the Biller",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while deleting the Biller",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }

  Future _createBiller() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    final String defaultDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final finalDate =
        date.value.text == '' ? defaultDate.toString() : date.value.text;
    try {
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        Map<String, dynamic> requestBody = {
          "userId": userMap['user_id'].toString(),
          "warehouseId": wareHouseID.value,
          "countryId": countryID.value,
          "firstName": firstName.value.text,
          "lastName": lastName.value.text,
          "phone": phone.value.text,
          "email": email.value.text,
          "city": city.value.text,
          "address": address.value.text,
          "zipCode": zipCode.value.text,
          "billerCode": billerCode.value.text,
          "nidPassportNumber": nidOrPassportNumber.value.text,
          "dateOfJoin": finalDate,
        };
        const url = "${AppStrings.baseUrlV1}billers/save";
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
          billerCode.value.text = '';
          address.value.text = '';
          isLoading.value = false;
          Get.back();
          Get.snackbar(
            "Success",
            "Billers Added Successfully",
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

class UpdateBillerController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = true.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();
  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> date = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final Rx<TextEditingController> billerCode = TextEditingController().obs;
  final Rx<TextEditingController> nidOrPassportNumber =
      TextEditingController().obs;
  final RxInt wareHouseID = 0.obs;
  final RxString wareHouseValue = ''.obs;

  void updateBiller(dynamic biller) async {
    isLoading.value = true;
    await _updateBiller(billerObj: biller);
    isLoading.value = false;
  }

  Future _updateBiller({required dynamic billerObj}) async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    final finalDate =
        date.value.text == '' ? billerObj['date_of_join'] : date.value.text;
    try {
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        Map<String, dynamic> requestBody = {
          "userId": userMap['user_id'].toString(),
          "warehouseId": wareHouseID.value == 0
              ? billerObj['warehouse_id']
              : wareHouseID.value,
          "countryId":
              countryID.value == 0 ? billerObj['country_id'] : countryID.value,
          "firstName": firstName.value.text == ''
              ? billerObj['first_name']
              : firstName.value.text,
          "lastName": lastName.value.text == ''
              ? billerObj['last_name']
              : lastName.value.text,
          "phone":
              phone.value.text == '' ? billerObj['phone'] : phone.value.text,
          "email":
              email.value.text == '' ? billerObj['email'] : email.value.text,
          "city": city.value.text == '' ? billerObj['city'] : city.value.text,
          "address": address.value.text == ''
              ? billerObj['address']
              : address.value.text,
          "zipCode": zipCode.value.text == ''
              ? billerObj['zip_code']
              : zipCode.value.text,
          "billerCode": billerCode.value.text == ''
              ? billerObj['biller_code']
              : billerCode.value.text,
          "nidPassportNumber": nidOrPassportNumber.value.text == ''
              ? billerObj['nid_passport_number']
              : nidOrPassportNumber.value.text,
          "dateOfJoin": finalDate,
          "_method": 'PUT',
        };
        final dynamic billerID = billerObj['id'];
        final url = "${AppStrings.baseUrlV1}billers/update/$billerID";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null) {
          firstName.value.text = '';
          lastName.value.text = '';
          email.value.text = '';
          phone.value.text = '';
          countryValue.value = '';
          city.value.text = '';
          zipCode.value.text = '';
          billerCode.value.text = '';
          address.value.text = '';
          isLoading.value = false;
          Get.back();
          Get.snackbar(
            "Success",
            "Billers Updated Successfully",
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
        "Fail Updated Product",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}
