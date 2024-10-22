import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCustomerController extends GetxController {
  final RxBool isLoading = true.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();

  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> rewardPoint = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final RxInt customerCategoryID = 0.obs;
  final RxString customerCategoryValue = ''.obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;
  void createCustomer() async {
    await _createCustomer();
  }

  Future _createCustomer() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    try {
      if (userString != null) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        Map<String, dynamic> requestBody = {
          "userId": userMap['user_id'].toString(),
          "countryId": countryID.value,
          "categoryId": customerCategoryID.value,
          "firstName": firstName.value.text,
          "lastName": lastName.value.text,
          "phone": phone.value.text,
          "email": email.value.text,
          "city": city.value.text,
          "address": address.value.text,
          "rewardPoint": rewardPoint.value.text,
          "zipCode": zipCode.value.text,
        };
        const url = "${AppStrings.baseUrlV1}customers/save";
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
          rewardPoint.value.text = '';
          address.value.text = '';
          isLoading.value = false;
          Get.back();
          Get.snackbar(
            "Success",
            "Customer Added Successfully",
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

class CustomerController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxBool deleteLoading = true.obs;
  final RxList<Map<String, dynamic>> customerList =
      <Map<String, dynamic>>[].obs;

  Future<bool> deleteCustomer(id) async {
    try {
      deleteLoading.value = true;

      final String changeIdType = id.toString();
      final String url =
          "${AppStrings.baseUrlV1}customers/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Customer deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the customer",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while deleting the customer",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }

  Future<void> fetchAllCustomers() async {
    try {
      isLoading.value = true;
      const url = "${AppStrings.baseUrlV1}customers/list";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;

        customerList.clear();
        customerList.addAll(data.map((item) {
          final firstName = item["first_name"] as String? ?? '';
          final lastName = item["last_name"] as String? ?? '';
          final phone = item["phone"] as String? ?? '';
          final email = item["email"] as String? ?? '';
          final city = item["city"] as String? ?? '';
          final categoryID = item["category_id"] as int? ?? 0;
          final countryID = item["country_id"] as int? ?? 0;
          final zipCode = item["zip_code"] as String? ?? '';
          final address = item["address"] as String? ?? 'Address Not Found';
          final reward = item["reward_point"] as String? ?? '00';
          final category = item["category"] as Map<String, dynamic>?;
          final country = item["country"] as Map<String, dynamic>?;

          final createdAtString = item["created_at"] ?? '';
          final createdAt = createdAtString.isNotEmpty
              ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ')
                  .parse(createdAtString, true)
              : null;
          final formattedCreatedAt = createdAt != null
              ? DateFormat('yyyy-MM-dd').format(createdAt.toLocal())
              : '';

          String purchaseDateAt = formattedCreatedAt;
          String formattedDate = '';

          if (purchaseDateAt.isNotEmpty) {
            try {
              final DateTime parsedDate = DateTime.parse(purchaseDateAt);
              formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = purchaseDateAt;
            }
          }

          return {
            "id": item["id"] as int? ?? 0,
            "name": "$firstName $lastName",
            "first_name": firstName,
            "last_name": lastName,
            "phone": phone,
            "email": email,
            "city": city,
            "zip_code": zipCode,
            "address": address,
            "reward": reward,
            "date": formattedDate,
            "category": category?["title"] as String? ?? 'Category Not Found',
            "country":
                country?["country_name"] as String? ?? 'country Not Found',
            "category_id": categoryID,
            "country_id": countryID
          };
        }).toList());

        customerList.refresh();
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

class UpdateCustomerController extends GetxController {
  final RxBool isLoading = true.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();

  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> city = TextEditingController().obs;
  final Rx<TextEditingController> zipCode = TextEditingController().obs;
  final Rx<TextEditingController> rewardPoint = TextEditingController().obs;
  final Rx<TextEditingController> address = TextEditingController().obs;
  final RxInt customerCategoryID = 0.obs;
  final RxString customerCategoryValue = ''.obs;
  final RxInt countryID = 0.obs;
  final RxString countryValue = ''.obs;
  void updateCustomer(dynamic customer) async {
    await _updateCustomer(customerObj: customer);
  }

  Future _updateCustomer({required dynamic customerObj}) async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    try {
      if (userString != null) {
        Map<String, dynamic> requestBody = {
          "countryId": countryID.value == 0
              ? customerObj['country_id']
              : countryID.value,
          "categoryId": customerCategoryID.value == 0
              ? customerObj['category_id']
              : customerCategoryID.value,
          "firstName": firstName.value.text == ''
              ? customerObj['first_name']
              : firstName.value.text,
          "lastName": lastName.value.text == ''
              ? customerObj['last_name']
              : lastName.value.text,
          "phone":
              phone.value.text == '' ? customerObj['phone'] : phone.value.text,
          "email":
              email.value.text == '' ? customerObj['email'] : email.value.text,
          "city": city.value.text == '' ? customerObj['city'] : city.value.text,
          "address": address.value.text == ''
              ? customerObj['address']
              : address.value.text,
          "rewardPoint": rewardPoint.value.text == ''
              ? customerObj['reward']
              : rewardPoint.value.text,
          "zipCode": zipCode.value.text == ''
              ? customerObj['zip_code']
              : zipCode.value.text,
          "_method": 'PUT',
        };
        final url =
            "${AppStrings.baseUrlV1}customers/update/${customerObj['id']}";
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
          rewardPoint.value.text = '';
          address.value.text = '';
          isLoading.value = false;
          Get.back();
          Get.snackbar(
            "Success",
            "Customer Update Successfully",
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
        "Fail Update Customer",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
    }
  }
}
