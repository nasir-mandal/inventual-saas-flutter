import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandController extends GetxController {
  final ProductDependencyController controller = ProductDependencyController();
  final NetworkApiServices _apiServices = NetworkApiServices();
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool deleteLoading = false.obs;
  final RxBool updateLoading = false.obs;
  final RxString deletedProductID = ''.obs;
  final Rx<TextEditingController> title = TextEditingController().obs;
  final Rx<TextEditingController> filePathController =
      TextEditingController().obs;

  Future<bool> updateBrand(dynamic brandObj) async {
    updateLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      final changeIdType = brandObj['id'].toString();
      final url = Uri.parse(
          "${await AppStrings.getBaseUrlV1()}brands/update/$changeIdType");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["title"] =
            title.value.text.isEmpty ? brandObj['title'] : title.value.text
        ..fields["_method"] = 'PUT';

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'brand_image', selectedFile.value!.path));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      updateLoading.value = false;

      if (jsonMap != null && jsonMap['success'] == true) {
        Get.back();
        controller.getAllBrands();

        title.value.text = '';

        Get.snackbar(
          "Success",
          "Brand Updated Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "${jsonMap['message'] ?? 'Failed to Update Brand'}",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to Update Brand",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      updateLoading.value = false;
      return false;
    }
  }

  Future<bool> deleteBrand(dynamic id) async {
    try {
      final changeIdType = id.toString();
      deleteLoading.value = true;
      final url =
          "${await AppStrings.getBaseUrlV1()}brands/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        deletedProductID.value = changeIdType;
        controller.getAllBrands();
        Get.snackbar(
          "Success",
          "Brand deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the brand",
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

  Future<bool> createBrand() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    try {
      final url = Uri.parse("${await AppStrings.getBaseUrlV1()}brands/save");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["title"] = title.value.text;

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'brand_image', selectedFile.value!.path));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      if (jsonMap != null && jsonMap["success"] == true) {
        controller.getAllBrands();
        title.value.text = '';
        Get.snackbar(
          "Success",
          "Brand Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to create the brand",
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
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedFile.value = File(image.path);
      String fileName = image.path.split('/').last;
      filePathController.value.text = fileName;
    }
  }
}
