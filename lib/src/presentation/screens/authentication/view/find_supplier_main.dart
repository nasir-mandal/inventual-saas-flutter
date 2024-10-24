import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inventual/src/presentation/screens/authentication/controller/find_supplier_controller.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/loadings/custom_loading.dart';
import 'package:inventual/src/utils/contstants.dart';

class FindSupplierMain extends StatelessWidget {
  const FindSupplierMain({super.key});

  @override
  Widget build(BuildContext context) {
    final FindSupplierController findSupplierController =
        Get.put(FindSupplierController());

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => findSupplierController.districtProgress.value
                ? const CustomLoading(opacity: true)
                : Container(
                    decoration: _buildGradientBackground(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAvatar(),
                        SizedBox(height: 5.h),
                        _buildTitle(),
                        SizedBox(height: 40.h),
                        _buildDropdownField(
                            "Select District",
                            findSupplierController.districtList.isEmpty
                                ? ["District Not Found"]
                                : findSupplierController.districtList
                                    .where((district) => district.title != null)
                                    .map((district) => district.title!)
                                    .toList(), (String? value) async {
                          findSupplierController.districtName.value = "";
                          findSupplierController.districtName.value = value!;
                          findSupplierController.districtId.value = 0;
                          findSupplierController.districtId.value =
                              findSupplierController.districtList
                                  .firstWhere(
                                      (district) => district.title == value)
                                  .id!;
                          await findSupplierController.getArea();
                        }),
                        SizedBox(height: 15.h),
                        Obx(() => findSupplierController.areaProgress.value
                            ? CustomLoading(opacity: true)
                            : _buildDropdownField(
                                "Select Area",
                                findSupplierController.areaList.isEmpty
                                    ? ["Area Not Found"]
                                    : findSupplierController.areaList
                                        .where((area) => area.title != null)
                                        .map((area) => area.title!)
                                        .toList(), (String? value) async {
                                findSupplierController.areaName.value = "";
                                findSupplierController.areaName.value = value!;
                                findSupplierController.areaId.value = 0;
                                findSupplierController.areaId.value =
                                    findSupplierController.areaList
                                        .firstWhere(
                                            (area) => area.title == value)
                                        .id!;
                                await findSupplierController.getSupplier();
                              })),
                        SizedBox(height: 15.h),
                        Obx(
                          () => findSupplierController.supplierProgress.value
                              ? CustomLoading(opacity: true)
                              : _buildDropdownField(
                                  "Select Supplier",
                                  findSupplierController.supplierList.isEmpty
                                      ? ["Supplier Not Found"]
                                      : findSupplierController.supplierList
                                          .where((supplier) =>
                                              supplier.storeName != null)
                                          .map(
                                              (supplier) => supplier.storeName!)
                                          .toList(), (String? value) async {
                                  findSupplierController.supplierName.value =
                                      "";
                                  findSupplierController.supplierName.value =
                                      value!;
                                  findSupplierController.supplierKey.value = "";
                                  findSupplierController.supplierKey.value =
                                      findSupplierController.supplierList
                                          .firstWhere((supplier) =>
                                              supplier.storeName == value)
                                          .supplierKey!;
                                  findSupplierController.supplierId.value = 0;
                                  findSupplierController.supplierId.value =
                                      findSupplierController.supplierList
                                          .firstWhere((supplier) =>
                                              supplier.storeName == value)
                                          .id!;
                                }),
                        ),
                        SizedBox(height: 15.h),
                        _buildVerifyButton(findSupplierController),
                        SizedBox(height: 70.h),
                      ],
                    ),
                  ),
          ),
          Obx(() => findSupplierController.verifyProgress.value
              ? CustomLoading(
                  opacity: findSupplierController.verifyProgress.value,
                )
              : const SizedBox()),
        ],
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ColorSchema.primaryColor,
          ColorSchema.secondaryColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1.0],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorSchema.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 45.r,
        backgroundColor: ColorSchema.white,
        child: Padding(
          padding: REdgeInsets.all(12.r),
          child: SvgPicture.asset("assets/images/logo/icon_logo.svg"),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Inventual",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ColorSchema.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildDropdownField(String hintText, List<String> items, onSelected) {
    return CustomDropdownField(
      hintTextColor: ColorSchema.black,
      expandedBorderRadius: 25,
      closedBorderRadius: 50,
      hintText: hintText,
      dropdownItems: items,
      onSelectedValueChanged: onSelected,
    );
  }

  Widget _buildVerifyButton(FindSupplierController findSupplierController) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorSchema.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: CustomElevatedButton(
        buttonColor: ColorSchema.primaryColor,
        buttonName: "Verify",
        onPressed: () => findSupplierController.supplierVerify(),
        buttonRadius: 50,
      ),
    );
  }
}
