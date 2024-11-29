import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/controller/become_a_seller_controller.dart';
import 'package:inventual_saas/src/presentation/screens/authentication/model/package_model.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/label_text/custom_label_text.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/custom_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/custom_text_field.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class BecomeASellerPaymentMethod extends StatefulWidget {
  const BecomeASellerPaymentMethod({super.key});

  @override
  State<BecomeASellerPaymentMethod> createState() =>
      _BecomeASellerPaymentMethodState();
}

class _BecomeASellerPaymentMethodState
    extends State<BecomeASellerPaymentMethod> {
  final BecomeASellerController controller = Get.put(BecomeASellerController());

  @override
  void initState() {
    super.initState();
    controller.getPackage();
    controller.selectedPaymentMethod.value = "Pay Later";
    controller.cuoponCodeController.text = "";
    controller.couponStatus.value = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: ColorSchema.white,
        centerTitle: true,
        title: Text(
          "Payment Method",
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
      body: Obx(
        () => controller.isLoading.value
            ? CustomLoading(opacity: controller.isLoading.value)
            : Container(
                color: ColorSchema.white,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    // Pay Later Radio Button
                    GestureDetector(
                      onTap: () {
                        controller.selectedPaymentMethod.value = 'Pay Later';
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                                color: ColorSchema.grey.withOpacity(0.5))),
                        child: Row(
                          children: [
                            Obx(() => Radio(
                                  activeColor: ColorSchema.primaryColor,
                                  value: 'Pay Later',
                                  groupValue:
                                      controller.selectedPaymentMethod.value,
                                  onChanged: (String? value) {
                                    controller.selectedPaymentMethod.value =
                                        value!;
                                  },
                                )),
                            Text(
                              "Pay Later",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorSchema.black,
                                  fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Cash On Delivery Radio Button
                    GestureDetector(
                      onTap: () {
                        controller.selectedPaymentMethod.value =
                            'Cash On Delivery';
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                                color: ColorSchema.grey.withOpacity(0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Obx(() => Radio(
                                      activeColor: ColorSchema.primaryColor,
                                      value: 'Cash On Delivery',
                                      groupValue: controller
                                          .selectedPaymentMethod.value,
                                      onChanged: (String? value) {
                                        controller.selectedPaymentMethod.value =
                                            value!;
                                      },
                                    )),
                                Text(
                                  "Cash On Delivery",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorSchema.black,
                                      fontSize: 14.sp),
                                ),
                              ],
                            )),
                            Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Image.network(
                                "https://inventual.app/build/assets/money-98cbcd2d.png",
                                width: 40.w,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Paypal Radio Button
                    GestureDetector(
                      onTap: () {
                        controller.selectedPaymentMethod.value = 'Paypal';
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                                color: ColorSchema.grey.withOpacity(0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Obx(() => Radio(
                                      activeColor: ColorSchema.primaryColor,
                                      value: 'Paypal',
                                      groupValue: controller
                                          .selectedPaymentMethod.value,
                                      onChanged: (String? value) {
                                        controller.selectedPaymentMethod.value =
                                            value!;
                                      },
                                    )),
                                Text(
                                  "Paypal",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorSchema.black,
                                      fontSize: 14.sp),
                                ),
                              ],
                            )),
                            Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Image.network(
                                "https://inventual.app/build/assets/paypal-8adce8ac.png",
                                width: 40.w,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Stripe Radio Button
                    GestureDetector(
                      onTap: () {
                        controller.selectedPaymentMethod.value = 'Stripe';
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                                color: ColorSchema.grey.withOpacity(0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Obx(() => Radio(
                                      activeColor: ColorSchema.primaryColor,
                                      value: 'Stripe',
                                      groupValue: controller
                                          .selectedPaymentMethod.value,
                                      onChanged: (String? value) {
                                        controller.selectedPaymentMethod.value =
                                            value!;
                                      },
                                    )),
                                Text(
                                  "Stripe",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorSchema.black,
                                      fontSize: 14.sp),
                                ),
                              ],
                            )),
                            Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Image.network(
                                "https://inventual.app/build/assets/stripe-00ca3ccb.png",
                                width: 40.w,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // Coupon Code Section
                    Row(
                      children: [
                        Container(
                          padding: REdgeInsets.all(3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                  color: ColorSchema.grey.withOpacity(0.4))),
                          child: Icon(
                            Icons.code,
                            size: 18,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Coupon Code",
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomLabelText(
                                text: "Coupon Code",
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              CustomTextField(
                                controller: controller.cuoponCodeController,
                                hintText: "Coupon",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomElevatedButton(
                          buttonName: "Apply",
                          onPressed: () => controller.getCouponCode(),
                          buttonRadius: 4,
                          buttonColor: ColorSchema.blue,
                        )
                      ],
                    ),
                    if (controller.couponStatus.isNotEmpty)
                      SizedBox(
                        height: 5.h,
                      ),
                    Obx(
                      () => Text(
                        controller.couponStatus.value,
                        style: TextStyle(
                          color: controller.couponStatus.value ==
                                  "Added Code Successfully"
                              ? ColorSchema.success
                              : ColorSchema.danger,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Packages :",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18.sp),
                    ),
                    Column(
                      children: controller.packageList.map((item) {
                        return Row(
                          children: [
                            Obx(() => Radio<PackageData>(
                                  activeColor: ColorSchema.primaryColor,
                                  value: item,
                                  groupValue: controller.selectedPackage.value,
                                  onChanged: (PackageData? selected) {
                                    controller.selectedPackage.value = selected;
                                    controller.packageID.value = 1;
                                    controller.packageID.value =
                                        selected!.id!.toInt();
                                  },
                                )),
                            Text(
                              item.title!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColorSchema.black,
                                  fontSize: 14.sp),
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                    SizedBox(
                      height: 10.h,
                    ),
                    CustomElevatedButton(
                      buttonName: "Make Payment",
                      onPressed: () => controller.makePayment(),
                      buttonRadius: 4,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
