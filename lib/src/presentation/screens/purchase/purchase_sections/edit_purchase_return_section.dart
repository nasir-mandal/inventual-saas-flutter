import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/dropdown_form_field_section.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class EditPurchaseReturnSection extends StatelessWidget {
  final dynamic purchase;

  const EditPurchaseReturnSection({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    const warehouseSelectionValue = "";

    List<String> warehouseItems = [
      "Warehouse 1",
      "Warehouse 2",
      "Warehouse 3",
      "Warehouse 4",
      "Warehouse 5"
    ];

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
                  "Edit Purchase Return",
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(children: [
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Supplier Name", inputType: TextInputType.name),
            const SizedBox(
              height: 20,
            ),
            DatePicker(labelText: "Date", hintText: purchase["date"]),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
              hint: "Reference",
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
              hint: "Remark",
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Amount", inputType: TextInputType.number),
            const SizedBox(
              height: 20,
            ),
            DropdownFormFieldSection(
                label: "Warehouse",
                hint: "Warehouse",
                items: warehouseItems,
                selectionItem: warehouseSelectionValue),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                buttonName: "Update Return Purchase",
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "${purchase["supplierName"]} Update Complete",
                      backgroundColor: ColorSchema.success);
                }),
            const SizedBox(
              height: 20,
            )
          ]),
        ))
      ],
    );
  }
}
