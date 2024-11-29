import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/controller/become_a_seller_controller.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/view/become_a_seller_payment_method.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/label_text/custom_label_text.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/custom_text_area.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/custom_text_field.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class BecomeASellerMain extends StatefulWidget {
  const BecomeASellerMain({super.key});

  @override
  State<BecomeASellerMain> createState() => _BecomeASellerMainState();
}

class _BecomeASellerMainState extends State<BecomeASellerMain> {
  final BecomeASellerController controller = Get.put(BecomeASellerController());
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: ColorSchema.white,
        centerTitle: true,
        title: Text(
          "Become a Seller",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            )),
      ),
      body: Container(
        color: ColorSchema.white,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Form(
            key: _formkey,
            child: ListView(
              children: [
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  children: [
                    Container(
                      padding: REdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                              color: ColorSchema.grey.withOpacity(0.4))),
                      child: Icon(
                        Icons.person_outline,
                        size: 18,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Owner Information",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18.sp),
                    )
                  ],
                ),
                Divider(
                  color: ColorSchema.grey.withOpacity(0.2),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "First Name",
                      isRequired: true,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      isValidator: true,
                      controller: controller.firstNameController,
                      hintText: "Steve",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Last Name",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.lastNameController,
                      hintText: "Smith",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Email",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "smith@gmail.com",
                      isEmail: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Phone",
                      isRequired: true,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.phoneController,
                      isValidator: true,
                      hintText: "+8801734604086",
                      isPhone: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "City",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.cityController,
                      hintText: "Manhaton",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Zip Code",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.zipCodeController,
                      hintText: "53167",
                      isNumeric: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Supplier Code",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.supplierCodeController,
                      hintText: "53167",
                      isNumeric: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Domain Name",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextField(
                      controller: controller.domainNameController,
                      hintText: "organist.com",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelText(
                      text: "Address",
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    CustomTextArea(
                      hintText: "Write Here...",
                      controllerName: controller.addressController,
                    )
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomElevatedButton(
                  buttonName: "Next",
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      Get.to(BecomeASellerPaymentMethod());
                    }
                  },
                  buttonRadius: 4,
                ),
                SizedBox(
                  height: 12.h,
                ),
              ],
            )),
      ),
    );
  }
}
