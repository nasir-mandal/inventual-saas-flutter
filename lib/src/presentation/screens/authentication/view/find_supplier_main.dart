import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:inventual/src/presentation/screens/authentication/controller/find_supplier_controller.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/utils/contstants.dart';

class FindSupplierMain extends StatelessWidget {
  const FindSupplierMain({super.key});

  @override
  Widget build(BuildContext context) {
    final FindSupplierController findSupplierController =
        Get.put(FindSupplierController());

    return Scaffold(
      backgroundColor: ColorSchema.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorSchema.primaryColor,
              ColorSchema.secondaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorSchema.black.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45.r,
                backgroundColor: ColorSchema.white,
                child: Padding(
                  padding: REdgeInsets.all(12.r),
                  child: SvgPicture.asset(
                    "assets/images/logo/icon_logo.svg",
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "Inventual",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorSchema.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 40.h),
            CustomDropdownField(
              hintTextColor: ColorSchema.black,
              expandedBorderRadius: 25,
              closedBorderRadius: 50,
              hintText: "Select District",
              dropdownItems: ["District 1", "District 2"],
              onSelectedValueChanged: (value) {},
            ),
            SizedBox(height: 15.h),
            CustomDropdownField(
              hintTextColor: ColorSchema.black,
              expandedBorderRadius: 25,
              closedBorderRadius: 50,
              hintText: "Select Area",
              dropdownItems: ["Area 1", "Area 2"],
              onSelectedValueChanged: (value) {},
            ),
            SizedBox(height: 15.h),
            CustomDropdownField(
              hintTextColor: ColorSchema.black,
              expandedBorderRadius: 25,
              closedBorderRadius: 50,
              hintText: "Select Supplier",
              dropdownItems: ["Supplier 1", "Supplier 2"],
              onSelectedValueChanged: (value) {},
            ),
            SizedBox(height: 15.h),
            CustomElevatedButton(
              buttonColor: ColorSchema.secondaryColor,
              buttonName: "Verify",
              onPressed: () {},
              buttonRadius: 50,
            ),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}
