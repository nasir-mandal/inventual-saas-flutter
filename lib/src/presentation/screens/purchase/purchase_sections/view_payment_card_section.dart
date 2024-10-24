import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/screens/purchase/purchase_sections/edit_purchase_section.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class ViewPaymentCardSection extends StatelessWidget {
  final dynamic payment;

  const ViewPaymentCardSection({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "View Payment",
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: ColorSchema.lightBlack,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 26,
                    color: ColorSchema.lightBlack,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            Divider(
              color: ColorSchema.grey.withOpacity(0.3),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(payment.value["supplierName"],
                      style: GoogleFonts.raleway(
                        color: ColorSchema.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(payment.value["statusColor"]),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(payment.value["status"],
                        style: GoogleFonts.nunito(
                          color: ColorSchema.white,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    size: 20,
                    color: ColorSchema.white54,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    payment.value["date"],
                    style: GoogleFonts.nunito(
                      color: ColorSchema.white54,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: SvgPicture.asset(
                      "assets/icons/icon_svg/reference_icon.svg",
                      color: ColorSchema.white54,
                      width: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    payment.value["reference"],
                    style: GoogleFonts.nunito(
                      color: ColorSchema.white54,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: SvgPicture.asset(
                      "assets/icons/icon_svg/view_payment.svg",
                      color: ColorSchema.white54,
                      width: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Card",
                    style: GoogleFonts.nunito(
                      color: ColorSchema.white54,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_svg/dollar_icon.svg",
                        width: 30,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        payment.value["grandTotal"],
                        style: GoogleFonts.nunito(
                            color: ColorSchema.white54,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ColorSchema.blue.withOpacity(0.05),
                        ),
                        child: IconButton(
                          icon: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SvgPicture.asset(
                              "assets/icons/icon_svg/edit_icon.svg",
                              color: ColorSchema.blue,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPurchaseSection(
                                        purchase: payment)));
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ColorSchema.red.withOpacity(0.05),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: SvgPicture.asset(
                            "assets/icons/icon_svg/delete_icon.svg",
                            color: ColorSchema.red,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
