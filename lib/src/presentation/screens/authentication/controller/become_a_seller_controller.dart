import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/model/coupon_code_model.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/model/package_model.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/view/payment_confirmation.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class BecomeASellerController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isCouponCodeLoading = false.obs;
  final NetworkApiServices _apiServices = NetworkApiServices();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final supplierCodeController = TextEditingController();
  final domainNameController = TextEditingController();
  final addressController = TextEditingController();
  final cuoponCodeController = TextEditingController();
  final RxList<PackageData> packageList = <PackageData>[].obs;
  final RxString selectedPaymentMethod = 'Pay Later'.obs;
  final RxString couponStatus = ''.obs;
  final RxInt couponID = 1.obs;
  final RxInt packageID = 0.obs;
  final Rx<PackageData?> selectedPackage = Rx<PackageData?>(null);

  Future<void> getPackage() async {
    isLoading.value = true;
    try {
      final String url = "https://inventual.app/api/v1/subscriptions/packages";
      final jsonResponse = await _apiServices.getApiBeforeAuthentication(url);
      final PackageModel response = PackageModel.fromJson(jsonResponse);
      packageList.clear();
      packageList.addAll(response.data!);
      final selected = packageList.firstWhere(
          (package) => package.title == "Free for one month",
          orElse: () => packageList.first);
      selectedPackage.value = selected;
      packageID.value = selected.id!;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), backgroundColor: ColorSchema.danger);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCouponCode() async {
    isCouponCodeLoading.value = true;
    try {
      if (cuoponCodeController.text.isNotEmpty) {
        final String url =
            "https://inventual.app/api/v1/subscriptions/coupon-code/check?code=${cuoponCodeController.text}";
        final jsonResponse = await _apiServices.getApiBeforeAuthentication(url);
        final CouponCodeModel response = CouponCodeModel.fromJson(jsonResponse);
        if (response.data != null) {
          couponStatus.value = "Added Code Successfully";
          couponID.value = response.data!.id!;
        } else {
          couponStatus.value = "Invalid Code!";
          couponID.value = 0;
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please Write Coupon Code",
            backgroundColor: ColorSchema.orange);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), backgroundColor: ColorSchema.danger);
    } finally {
      isCouponCodeLoading.value = false;
    }
  }

  Future<void> makePayment() async {
    try {
      final String url = "https://inventual.app/api/v1/sellers/save";
      final Map<String, String> requestBody = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "city": cityController.text,
        "zipCode": zipCodeController.text,
        "supplierCode": supplierCodeController.text,
        "domainName": domainNameController.text,
        "paymentMethod": selectedPaymentMethod.value,
        "couponId": couponID.toString(),
        "subscriptionPackageId": packageID.toString(),
        "transactionNumber": ""
      };
      final jsonResponse = await _apiServices.loginApi(requestBody, url);
      if (jsonResponse != null && jsonResponse['success']) {
        Fluttertoast.showToast(
            msg: "Payment Complete", backgroundColor: ColorSchema.success);
        clearController();
      }
      Get.off(ConfirmationScreen());
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), backgroundColor: ColorSchema.danger);
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    supplierCodeController.dispose();
    domainNameController.dispose();
    addressController.dispose();
    cuoponCodeController.dispose();
  }

  void clearController() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    cityController.clear();
    zipCodeController.clear();
    supplierCodeController.clear();
    domainNameController.clear();
    addressController.clear();
    cuoponCodeController.clear();
    couponStatus.value = '';
    couponID.value = 0;
    packageID.value = 0;
  }
}
