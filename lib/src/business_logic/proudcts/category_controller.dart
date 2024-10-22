import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends GetxController {
  final Rx<TextEditingController> filePathController =
      TextEditingController().obs;
  final Rx<File?> selectedFile = Rx<File?>(null);
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool isDynamicLoading = true.obs;
  final RxBool deleteLoading = false.obs;
  final RxBool allCategoryLoading = true.obs;
  final RxBool allCategoryLoadingTwo = true.obs;
  final RxBool updateLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxString parentCategoryValue = ''.obs;
  final RxInt parentCategoryID = 0.obs;
  final RxString categoryTypeValue = ''.obs;
  final RxInt categoryTypeID = 0.obs;
  final Rx<TextEditingController> category = TextEditingController().obs;
  final Rx<TextEditingController> date = TextEditingController().obs;
  final RxList<Map<String, dynamic>> parentCategoryList =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> dynamicCategoryList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allCategoryList =
      <Map<String, dynamic>>[].obs;

  void getAllCategory() async {
    allCategoryLoading.value = true;
    await fetchAllCategories();
    allCategoryLoading.value = false;
  }

  void getAllDynamicCategory(dynamic categoryType) async {
    isDynamicLoading.value = true;
    await fetchDynamicTypeCategories(categoryType: categoryType);
    isDynamicLoading.value = false;
  }

  Future<bool> updateCategory(dynamic categoryObj) async {
    updateLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    final String parentID =
        parentCategoryID.value == 0 ? '' : parentCategoryID.value.toString();

    try {
      final changeIdType = categoryObj['category_id'].toString();
      final url =
          Uri.parse("${AppStrings.baseUrlV1}category/update/$changeIdType");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final parentId = parentID.isEmpty
          ? (categoryObj['parent_id'] == 0
              ? ''
              : categoryObj['parent_id'].toString())
          : parentID;

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["parent_id"] = parentId
        ..fields["type"] = categoryTypeValue.value.isEmpty
            ? categoryObj['type']
            : categoryTypeValue.value
        ..fields["title"] = category.value.text.isEmpty
            ? categoryObj['title']
            : category.value.text
        ..fields["_method"] = 'PUT';

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'category_image', selectedFile.value!.path));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      updateLoading.value = false;

      if (jsonMap != null && jsonMap['success'] == true) {
        category.value.text = '';
        Get.snackbar(
          "Success",
          "Category Updated Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to Update Category",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to Update Category",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      updateLoading.value = false;
      return false;
    }
  }

  Future<bool> createCategory() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    final String parentID = parentCategoryID.value.toString();

    try {
      final url = Uri.parse("${AppStrings.baseUrlV1}category/save");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["parent_id"] = parentCategoryID.value == 0 ? '' : parentID
        ..fields["type"] = categoryTypeValue.value
        ..fields["title"] = category.value.text;

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'category_image',
          selectedFile.value!.path,
        ));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      if (jsonMap != null && jsonMap['success'] == true) {
        category.value.text = '';

        Get.snackbar(
          "Success",
          "Category Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to create category",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDynamicTypeCategories(
      {required dynamic categoryType}) async {
    try {
      isDynamicLoading.value = true;
      final url = "${AppStrings.baseUrlV1}category/list?type=$categoryType";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
        dynamicCategoryList.clear();
        for (var item in data) {
          final parent = item['parent'] ?? {};

          String imagePath = '';
          if (item["images"] != null && item["images"].isNotEmpty) {
            imagePath = "${AppStrings.baseImgURL}${item["images"][0]["path"]}";
          }

          dynamicCategoryList.add({
            "category_id": item["id"] ?? 0,
            "title": item["title"] ?? '',
            "parent_id": item["parent_id"] ?? 0,
            "type": item["type"] ?? '',
            "parent": {
              "parent_id": parent["id"] ?? 0,
              "title": parent["title"] ?? '',
              "description": parent["description"] ?? 'No Description Added',
              "status": parent["status"] ?? 'Unknown',
            },
            "images": imagePath,
          });
        }
        isDynamicLoading.value = false;
        if (dynamicCategoryList.isEmpty) {
          isDynamicLoading.value = false;
          Get.snackbar(
            "Info",
            "No categories found.",
            backgroundColor: ColorSchema.grey.withOpacity(0.5),
            colorText: ColorSchema.white,
            animationDuration: const Duration(milliseconds: 800),
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "No data found or data is null.",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
      }
    } catch (e) {
      isDynamicLoading.value = false;
      Get.snackbar(
        "Error",
        "Report Not Found",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
    } finally {
      isDynamicLoading.value = false;
    }
  }

  Future<void> fetchAllCategories() async {
    try {
      allCategoryLoading.value = true;

      const url = "${AppStrings.baseUrlV1}category/list";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);

        allCategoryList.clear();

        for (var item in data) {
          final parent = item['parent'] ?? {};

          String imagePath = '';
          if (item["images"] != null && item["images"].isNotEmpty) {
            imagePath = "${AppStrings.baseImgURL}${item["images"][0]["path"]}";
          }

          allCategoryList.add({
            "category_id": item["id"] ?? 0,
            "title": item["title"] ?? '',
            "parent_id": item["parent_id"] ?? 0,
            "type": item["type"] ?? '',
            "parent": {
              "parent_id": parent["id"] ?? 0,
              "title": parent["title"] ?? '',
              "description": parent["description"] ?? 'No Description Added',
              "status": parent["status"] ?? 'Unknown',
            },
            "images": imagePath,
          });
        }
      }
    } catch (e) {
      allCategoryLoading.value = false;
    } finally {
      allCategoryLoading.value = false;
    }
  }

  Future<bool> deleteCategory(dynamic id) async {
    try {
      final changeIdType = id.toString();
      deleteLoading.value = true;
      final url = "${AppStrings.baseUrlV1}category/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);
      if (jsonResponse["data"] == true && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "Category deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the category",
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
