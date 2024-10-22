import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateUserController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rx<File?> selectedFile = Rx<File?>(null);
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> username = TextEditingController().obs;
  final Rx<TextEditingController> password = TextEditingController().obs;
  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final RxInt roleID = 0.obs;
  final RxString roleValue = ''.obs;
  final RxInt genderID = 0.obs;
  final RxString genderIDValue = ''.obs;
  final Rx<TextEditingController> filePathController =
      TextEditingController().obs;

  Future<bool> createUser() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    try {
      final url = Uri.parse("${AppStrings.baseUrlV1}users/register");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["email"] = email.value.text
        ..fields["username"] = username.value.text
        ..fields["password"] = password.value.text
        ..fields["firstName"] = firstName.value.text
        ..fields["lastName"] = lastName.value.text
        ..fields["phone"] = phone.value.text
        ..fields["roleId"] = roleID.value.toString()
        ..fields["gender"] = genderIDValue.value
        ..fields["status"] = 'Pending';

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', selectedFile.value!.path));
      }
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      isLoading.value = false;
      if (jsonMap['success'] == true) {
        email.value.text = '';
        username.value.text = '';
        password.value.text = '';
        firstName.value.text = '';
        lastName.value.text = '';
        phone.value.text = '';
        genderIDValue.value = '';
        Get.back();
        Get.snackbar(
          "Success",
          "User Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "${jsonMap['message']}",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to Create User",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      isLoading.value = false;
      return false;
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

class UserListController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxBool deleteLoading = true.obs;
  final RxList<Map<String, dynamic>> usersList = <Map<String, dynamic>>[].obs;
  Future<bool> deleteUser(int id) async {
    try {
      deleteLoading.value = true;

      final String changeIdType = id.toString();
      final String url = "${AppStrings.baseUrlV1}users/delete/$changeIdType";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        Get.snackbar(
          "Success",
          "User deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the User",
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

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      const url = "${AppStrings.baseUrlV1}users/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        usersList.clear();
        usersList.addAll(data.map((item) {
          final imagePath =
              item["image"] != null ? item["image"]["path"] as String : null;
          final roles = item["roles"] as List?;

          final userRole = roles != null && roles.isNotEmpty
              ? roles.map((role) => role["name"] as String).join(", ")
              : "No Role Assigned";

          final userRoleId = roles != null && roles.isNotEmpty
              ? roles.map((role) => role["id"].toString()).join(", ")
              : "No Role ID";

          final fullImageUrl =
              imagePath != null ? "${AppStrings.baseImgURL}$imagePath" : null;

          final createdAtString = item["created_at"] ?? '';
          final formattedCreatedAt = createdAtString.isNotEmpty
              ? DateFormat('yyyy-MM-dd').format(
                  DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ')
                      .parse(createdAtString, true)
                      .toLocal())
              : '';

          String userCreateDateAt = formattedCreatedAt;
          String formattedDate = '';

          if (userCreateDateAt.isNotEmpty) {
            try {
              final DateTime parsedDate = DateTime.parse(userCreateDateAt);
              formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = userCreateDateAt;
            }
          }

          return {
            "id": item["id"] as int? ?? 0,
            "first_name": item["first_name"] as String? ?? '',
            "last_name": item["last_name"] as String? ?? '',
            "name":
                "${item["first_name"] as String? ?? ''} ${item["last_name"] as String? ?? ''}",
            "email": item["email"] as String? ?? '',
            "phone": item["phone"] as String? ?? '',
            "gender": item["gender"] ?? 'Not Found',
            "username": item["username"] ?? 'Not Found',
            "image": fullImageUrl ?? '',
            "role": userRole,
            "roleId": userRoleId,
            "date": formattedDate,
          };
        }).toList());

        usersList.refresh();
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class UpdateUserController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isLoading = true.obs;
  final RxBool updateLoading = true.obs;
  final Rx<TextEditingController> email = TextEditingController().obs;
  final Rx<TextEditingController> username = TextEditingController().obs;
  final Rx<TextEditingController> firstName = TextEditingController().obs;
  final Rx<TextEditingController> lastName = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> filePathController =
      TextEditingController().obs;
  final RxInt roleID = 0.obs;
  final RxString roleValue = ''.obs;
  final RxInt genderID = 0.obs;
  final RxString genderIDValue = ''.obs;

  Future<bool> updateUserInfo(dynamic userObj) async {
    updateLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    try {
      final changeIdType = userObj['id'].toString();
      final url =
          Uri.parse("${AppStrings.baseUrlV1}users/update/$changeIdType");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["email"] =
            email.value.text == '' ? userObj['email'] : email.value.text
        ..fields["username"] = username.value.text == ''
            ? userObj['username']
            : username.value.text
        ..fields["first_name"] = firstName.value.text == ''
            ? userObj['first_name']
            : firstName.value.text
        ..fields["last_name"] = lastName.value.text == ''
            ? userObj['last_name']
            : lastName.value.text
        ..fields["phone"] =
            phone.value.text == '' ? userObj['phone'] : phone.value.text
        ..fields["roleId"] =
            roleID.value == 0 ? userObj['roleId'] : roleID.value.toString()
        ..fields["gender"] =
            genderID.value == 0 ? userObj['gender'] : genderIDValue.value
        ..fields["_method"] = 'PUT';

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', selectedFile.value!.path));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      if (jsonMap != null) {
        Get.snackbar(
          "Success",
          "User Updated Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        updateLoading.value = false;
        return true;
      } else {
        updateLoading.value = false;
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to Update User",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      updateLoading.value = false;
      return false;
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
