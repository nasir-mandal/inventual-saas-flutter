import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/dropdown_form_field_section.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class EditPurchaseSection extends StatelessWidget {
  final dynamic purchase;

  const EditPurchaseSection({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    const warehouseSelectedValue = "";

    List<String> warehouseItems = [
      "Warehouse 1",
      "Warehouse 2",
      "Warehouse 3",
      "Warehouse 4",
      "Warehouse 5"
    ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          navigateName: "Edit Purchase",
        ),
      ),
      body: Container(
        color: ColorSchema.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            DatePicker(
              labelText: "Date",
              hintText: purchase.value["date"],
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Supplier Name", inputType: TextInputType.name),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Reference", inputType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
              hint: "Status",
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
              hint: "Payment",
              inputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
              hint: "Grand Total",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
              hint: "Paid",
              inputType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Due", inputType: TextInputType.number),
            const SizedBox(
              height: 20,
            ),
            DropdownFormFieldSection(
                label: "Warehouse",
                hint: purchase.value["warehouse"],
                items: warehouseItems,
                selectionItem: warehouseSelectedValue),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                buttonName: "Update",
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Purchase Update Complete",
                      backgroundColor: ColorSchema.success);
                }),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
