import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool roleLoading = true.obs;
  final RxBool deleteLoading = true.obs;
  final RxBool updateLoading = false.obs;
  final Rx<TextEditingController> name = TextEditingController().obs;
  final RxList<Map<String, dynamic>> roleList = <Map<String, dynamic>>[].obs;

  void fetchAllRole() async {
    roleLoading.value = true;
    await fetchAllRoles();
    roleLoading.value = false;
  }

  void updateRole(dynamic role) async {
    updateLoading.value = true;
    await _updateRole(roleObj: role);
    updateLoading.value = false;
  }

  Future<void> _updateRole({required dynamic roleObj}) async {
    updateLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    try {
      final changeIdType = roleObj['id'].toString();
      final url = Uri.parse(
          "${await AppStrings.getBaseUrlV1()}roles/update/$changeIdType");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["name"] =
            name.value.text == '' ? roleObj['name'] : name.value.text
        ..fields["_method"] = 'PUT';

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      if (jsonMap != null) {
        name.value.text = '';
        Get.snackbar(
          "Success",
          "Role Updated Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        updateLoading.value = false;
      } else {
        updateLoading.value = false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to Update Role",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      updateLoading.value = false;
    }
  }

  Future<bool> deleteRoles(dynamic id) async {
    try {
      final changeIdType = id.toString();
      deleteLoading.value = true;
      final url =
          "${await AppStrings.getBaseUrlV1()}roles/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Role deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
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

  Future<bool> createRole() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userString = prefs.getString("user");
      if (userString != null) {
        jsonDecode(userString);
        Map<String, dynamic> requestBody = {"name": name.value.text};
        final url = "${await AppStrings.getBaseUrlV1()}roles/save";
        final jsonResponse = await _apiServices.postApiV2(requestBody, url);
        if (jsonResponse != null && jsonResponse["success"] == true) {
          name.value.text = '';
          Get.snackbar(
            "Success",
            "Role Added Successfully",
            backgroundColor: ColorSchema.success.withOpacity(0.5),
            colorText: ColorSchema.white,
            animationDuration: const Duration(milliseconds: 800),
          );
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllRoles() async {
    try {
      roleLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}roles/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
        roleList.clear();
        roleList.addAll(data);
        roleLoading.value = false;
      } else {
        roleLoading.value = false;
      }
    } catch (e) {
      roleLoading.value = false;
    } finally {
      roleLoading.value = false;
    }
  }
}
