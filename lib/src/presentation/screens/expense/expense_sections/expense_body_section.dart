import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/business_logic/expense/add_expense.dart';
import 'package:inventual/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/data/models/expense_model/expense_type.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';

class ExpenseBodySection extends StatefulWidget {
  const ExpenseBodySection({super.key});

  @override
  State<ExpenseBodySection> createState() => _ExpenseBodySectionState();
}

class _ExpenseBodySectionState extends State<ExpenseBodySection> {
  final ProductDependencyController _dependencyController =
      ProductDependencyController();

  final AddExpenseController _createController = AddExpenseController();
  final CategoryController categoryController = CategoryController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _dependencyController.getAllWareHouse();
    _dependencyController.getAllSuppliers();
    categoryController.getAllDynamicCategory("Expense");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            GloballyDatePicker(
              labelText: "Date",
              hintText: "MM/DD/YYYY",
              controller: _createController.date.value,
            ),
            const SizedBox(
              height: 20,
            ),
            buildInputTextField(
                "Voucher No",
                TextInputType.number,
                _createController.voucherNo.value,
                "Voucher No Is Required Field"),
            const SizedBox(
              height: 20,
            ),
            buildInputTextField("Amount", TextInputType.number,
                _createController.amount.value, "Amount Is Required Field"),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() => CustomDropdownField(
                      hintText: "Ware House Id",
                      dropdownItems: _dependencyController.wareHouseList
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.wareHouseValue.value = value;
                        _createController.wareHouseID.value =
                            _dependencyController.wareHouseList.firstWhere(
                                (item) => item["title"] == value)["id"];
                      })),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomDropdownField(
                      hintText: "Expense Type",
                      dropdownItems: expenseTypeData
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.expenseTypeValue.value = value;
                        _createController.expenseID.value = expenseTypeData
                            .firstWhere((item) => item["title"] == value)["id"];
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() => CustomDropdownField(
                      hintText: "Select Supplier",
                      dropdownItems: _dependencyController.suppliersList
                          .map((item) => item["first_name"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.supplierValue.value = value;
                        _createController.supplierID.value =
                            _dependencyController.suppliersList.firstWhere(
                                (item) => item["first_name"] == value)["id"];
                      })),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() => CustomDropdownField(
                      hintText: "Select Category",
                      dropdownItems: categoryController.dynamicCategoryList
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.categoryValue.value = value;
                        _createController.categoryID.value = categoryController
                                .dynamicCategoryList
                                .firstWhere((item) => item["title"] == value)[
                            "category_id"];
                      })),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            buildOptionalInputTextField(
              "Expense Note",
              TextInputType.text,
              _createController.notes.value,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.maxFinite,
              child: buildFromSubmitButton(
                  checkValidation: _createExpense, buttonName: "Submit"),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  _createExpense() {
    if (_formKey.currentState!.validate()) {
      _createController.createExpense();
    }
  }
}
