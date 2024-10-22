import 'package:flutter/material.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/date_picker.dart';
import 'package:inventual/src/presentation/widgets/text_field/dropdown_form_field_section.dart';
import 'package:inventual/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:inventual/src/presentation/widgets/toast/success_toast.dart';
import 'package:inventual/src/utils/contstants.dart';

class EditSalesSection extends StatelessWidget {
  final dynamic sales;

  const EditSalesSection({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    const warehouseSelectedValue = "";
    const statusSelectedValue = "";
    const paymentSelectedValue = "";

    List<String> warehouseItems = [
      "Warehouse 1",
      "Warehouse 2",
      "Warehouse 3",
      "Warehouse 4",
      "Warehouse 5"
    ];
    List<String> statusItems = ["Completed", "Draft", "Ordered"];
    List<String> paymentItems = ["Paid", "Unpaid", "Partial"];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Edit Sale"),
      ),
      body: Container(
        color: ColorSchema.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            DatePicker(labelText: "Date", hintText: sales.value["date"]),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Customer Name", inputType: TextInputType.name),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Biller Name", inputType: TextInputType.name),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Reference No", inputType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Grand Total", inputType: TextInputType.number),
            const SizedBox(
              height: 20,
            ),
            const TextFieldSection(
                hint: "Paid", inputType: TextInputType.number),
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
                hint: sales.value["warehouse"],
                items: warehouseItems,
                selectionItem: warehouseSelectedValue),
            const SizedBox(
              height: 20,
            ),
            DropdownFormFieldSection(
                label: "Status",
                hint: sales.value["status"],
                items: statusItems,
                selectionItem: statusSelectedValue),
            const SizedBox(
              height: 20,
            ),
            DropdownFormFieldSection(
                label: "Payment Status",
                hint: sales.value["payment"],
                items: paymentItems,
                selectionItem: paymentSelectedValue),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                buttonName: "Update Sale",
                onPressed: () {
                  SuccessToast.showSuccessToast(
                      context, "Update Complete", "Sale Update Complete");
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
