import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/dropdown_form_field_section.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/text_field_max_line_section.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class AddPaymentSection extends StatelessWidget {
  final dynamic payment;

  const AddPaymentSection({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    const paymentSelectedValue = "";

    List<String> paymentItems = ["Card", "Bank", "Cash"];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Add Payment",
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
        ),
        Divider(
          color: ColorSchema.grey.withOpacity(0.3),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              const TextFieldSection(
                  hint: "Received Amount", inputType: TextInputType.number),
              const SizedBox(
                height: 20,
              ),
              const TextFieldSection(
                  hint: "Paying Amount", inputType: TextInputType.number),
              const SizedBox(
                height: 20,
              ),
              const TextFieldSection(
                  hint: "Charge", inputType: TextInputType.number),
              const SizedBox(
                height: 20,
              ),
              const TextFieldSection(
                  hint: "Card Number", inputType: TextInputType.number),
              const SizedBox(
                height: 20,
              ),
              const DatePicker(
                  labelText: "Expired Date", hintText: "MM/DD/YYYY"),
              const SizedBox(
                height: 20,
              ),
              DropdownFormFieldSection(
                  label: "Payment Type",
                  hint: "Select Payment Type",
                  items: paymentItems,
                  selectionItem: paymentSelectedValue),
              const SizedBox(
                height: 20,
              ),
              const TextFieldMaxLineSection(
                  labelText: "Sale Note", hintText: "Type Sales Note"),
              const SizedBox(
                height: 20,
              ),
              CustomElevatedButton(
                  buttonName: "Pay Now",
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg:
                            "${payment.value["supplierName"]} Payment Complete",
                        backgroundColor: ColorSchema.success);
                  }),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ))
      ],
    );
  }
}
