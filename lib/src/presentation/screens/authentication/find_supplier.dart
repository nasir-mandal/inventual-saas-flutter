import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/utils/contstants.dart';

class FindSupplier extends StatelessWidget {
  const FindSupplier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchema.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/logo/logo.svg"),
              SizedBox(
                height: 30.h,
              ),
              CustomDropdownField(
                  hintText: "District",
                  dropdownItems: [],
                  onSelectedValueChanged: (value) {}),
              SizedBox(
                height: 10.h,
              ),
              CustomDropdownField(
                  hintText: "Area",
                  dropdownItems: [],
                  onSelectedValueChanged: (value) {}),
              SizedBox(
                height: 10.h,
              ),
              CustomDropdownField(
                  hintText: "Supplier",
                  dropdownItems: [],
                  onSelectedValueChanged: (value) {}),
            ],
          ),
        ),
      ),
    );
  }
}
