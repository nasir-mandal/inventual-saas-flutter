import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/authentication.dart';
import 'package:inventual_saas/src/business_logic/people/customer/customer_controller.dart';
import 'package:inventual_saas/src/business_logic/pos_sale/sales_return.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/data/models/expense_model/expense_type.dart';
import 'package:inventual_saas/src/presentation/screens/sales/salesSections/create_sales_return/create_sales_return_main_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesReturnBillsSection extends StatefulWidget {
  final dynamic product;

  const SalesReturnBillsSection({super.key, required this.product});

  @override
  State<SalesReturnBillsSection> createState() =>
      _PurchaseReturnBillsSectionState();
}

class _PurchaseReturnBillsSectionState extends State<SalesReturnBillsSection> {
  final CreateSalesReturnController _createController =
      CreateSalesReturnController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final UserController userInfo = UserController();
  final CustomerController customerController = CustomerController();
  late List<int> quantities;
  late List<double> subtotals;
  late Map<String, dynamic> settings = {};

  @override
  void initState() {
    super.initState();
    userInfo.loadUser();
    _dependencyController.getAllWareHouse();
    _dependencyController.getAllBillers();
    customerController.fetchAllCustomers();
    quantities = List<int>.filled(widget.product.length, 1);
    subtotals = List<double>.filled(widget.product.length, 0);
    _createController.calculateSubtotals(
        product: widget.product, quantities: quantities, subtotals: subtotals);
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      quantities[index] = newQuantity;
      _createController.calculateSubtotals(
          product: widget.product,
          quantities: quantities,
          subtotals: subtotals);
    });
  }

  List<Map<String, dynamic>> transformProducts(List<dynamic> products) {
    return products.asMap().entries.map((entry) {
      int index = entry.key;
      var product = entry.value;
      return {
        "product_id": product["id"],
        "amount": product["price"],
        "quantity": quantities[index],
        "tax_amount": product["tax"],
        "discount": product["discount"],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("settings");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(navigateName: "Return Sales Bills")),
      body: Container(
        color: ColorSchema.white70,
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => GloballyDatePicker(
                          labelText: "Date",
                          hintText: "MM/DD/YYYY",
                          controller: _createController.date.value,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildOptionalInputTextField("Return Note",
                  TextInputType.text, _createController.returnNote.value),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildOptionalInputTextField(
                  "Remark", TextInputType.text, _createController.remark.value),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => CustomDropdownField(
                        hintText: "Select Ware House",
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
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => CustomDropdownField(
                  hintText: "Select Biller",
                  dropdownItems: _dependencyController.billersList
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.billerValue.value = value;
                    _createController.billerID.value = _dependencyController
                        .billersList
                        .firstWhere((item) => item["title"] == value)["id"];
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => CustomDropdownField(
                  hintText: "Select Customer",
                  dropdownItems: customerController.customerList
                      .map((item) => item["name"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.customerIDValue.value = value;
                    _createController.customerID.value = customerController
                        .customerList
                        .firstWhere((item) => item["name"] == value)["id"];
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomDropdownField(
                  hintText: "Return Status",
                  dropdownItems: purchaseStatusData
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.returnStatusValue.value = value;
                    _createController.returnStatusID.value = purchaseStatusData
                        .firstWhere((item) => item["title"] == value)["id"];
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.product.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Return Sales Item",
                      style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20)),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            if (widget.product.isEmpty)
              Center(
                child: Column(
                  children: [
                    Text(
                      'No products item available',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorSchema.grey.withOpacity(0.4)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                        buttonName: "Select Sales Return Item",
                        onPressed: () {
                          Get.off(const CreateSalesReturnMainScreen());
                        })
                  ],
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DataTable(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ColorSchema.borderColor, width: 1)),
                    columnSpacing: 35,
                    headingRowHeight: 50,
                    dataRowHeight: 70,
                    headingRowColor: MaterialStateProperty.all(
                        ColorSchema.grey.withOpacity(0.1)),
                    dividerThickness: 0.25,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Products',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tax',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Discount',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Price',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Quantity',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Sub Total',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Action',
                          style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        numeric: true,
                      ),
                    ],
                    rows: List.generate(
                      widget.product.length,
                      (index) {
                        return DataRow(
                          cells: [
                            DataCell(Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.product[index]['title'],
                                    style: GoogleFonts.raleway(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600))),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Batch :  ${widget.product[index]["barcode_id"]}",
                                  style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                          color: ColorSchema.grey
                                              .withOpacity(0.5))),
                                )
                              ],
                            )),
                            DataCell(Text("${widget.product[index]["tax"]}%",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle()))),
                            DataCell(Text(
                                "${widget.product[index]["discount"]}%",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle()))),
                            DataCell(Text(
                                "${settings['currency_symbol']}${widget.product[index]['price']}",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle()))),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (quantities[index] > 1) {
                                      setState(() {
                                        _updateQuantity(
                                            index, quantities[index] - 1);
                                        _createController.calculateSubtotals(
                                            product: widget.product,
                                            quantities: quantities,
                                            subtotals: subtotals);
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: ColorSchema.borderLightBlue,
                                            width: 2)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SvgPicture.asset(
                                        "assets/icons/icon_svg/minus_button.svg",
                                        width: 12,
                                        color: ColorSchema.borderLightBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${quantities[index]}",
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(fontSize: 18)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _updateQuantity(
                                          index, quantities[index] + 1);
                                      _createController.calculateSubtotals(
                                          product: widget.product,
                                          quantities: quantities,
                                          subtotals: subtotals);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorSchema.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: ColorSchema.primaryColor,
                                            width: 2)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: SvgPicture.asset(
                                        "assets/icons/icon_svg/plus_button.svg",
                                        width: 12,
                                        color: ColorSchema.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            DataCell(Text(
                                "${settings['currency_symbol']}${subtotals[index].toStringAsFixed(2)}",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle()))),
                            DataCell(
                              GestureDetector(
                                onTap: () {
                                  showConfirmationDialog(context, () {
                                    setState(() {
                                      widget.product.removeAt(index);
                                    });

                                    _createController.calculateSubtotals(
                                        product: widget.product,
                                        quantities: quantities,
                                        subtotals: subtotals);
                                  }, "Are you sure you want to remove this item?");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: ColorSchema.red, width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      "assets/icons/icon_svg/close_icon.svg",
                                      width: 12,
                                      color: ColorSchema.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            widget.product.isEmpty
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      color: ColorSchema.borderLightBlue,
                    ),
                  ),
            Obx(() => widget.product.isEmpty
                ? const SizedBox()
                : buildTotalSection()),
            const SizedBox(
              height: 20,
            ),
            Obx(() => widget.product.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller:
                          _createController.shippingAmount.value as dynamic,
                      onChanged: (value) {
                        _createController.calculateSubtotals(
                            product: widget.product,
                            quantities: quantities,
                            subtotals: subtotals);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        fillColor: ColorSchema.white,
                        filled: true,
                        hintText: "Enter Shipping Amount",
                        hintStyle: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                            color: ColorSchema.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: ColorSchema.borderColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ColorSchema.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.number,
                    ))),
            const SizedBox(
              height: 20,
            ),
            Obx(() => widget.product.isEmpty
                ? const SizedBox()
                : buildGrandTotalSection()),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildElevatedButton(
                      "Reset", ColorSchema.danger.withOpacity(0.7)),
                  buildElevatedButton(
                      "Save Return Sales", ColorSchema.analyticsColor2),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Padding buildGrandTotalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorSchema.lightGray,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: ColorSchema.borderLightBlue, width: 1)),
        child: Text(
          "Grand Total : ${settings['currency_symbol']}${_createController.totalSubtotals.toStringAsFixed(2)}",
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  SingleChildScrollView buildTotalSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 50,
        headingRowHeight: 30,
        dataRowHeight: 50,
        border: TableBorder.all(
          color: ColorSchema.white,
        ),
        dividerThickness: 0,
        columns: [
          DataColumn(
            label: Text("Total",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          DataColumn(
            label: Text("Item",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          DataColumn(
            label: Text("Tax",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          DataColumn(
            label: Text("Discount",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold))),
          ),
          DataColumn(
            label: Text("Subtotal",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold))),
          ),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text(
              "${settings['currency_symbol']}${_createController.totalAmount}",
              style: GoogleFonts.nunito(textStyle: const TextStyle()),
            )),
            DataCell(Text(
              "${widget.product.length}",
              style: GoogleFonts.nunito(textStyle: const TextStyle()),
            )),
            DataCell(Text(
              _createController.totalTax.toStringAsFixed(2),
              style: GoogleFonts.nunito(textStyle: const TextStyle()),
            )),
            DataCell(Text(
              _createController.totalDiscount.toStringAsFixed(2),
              style: GoogleFonts.nunito(textStyle: const TextStyle()),
            )),
            DataCell(Text(
              "${_createController.totalSubtotals}",
              style: GoogleFonts.nunito(textStyle: const TextStyle()),
            )),
          ])
        ],
      ),
    );
  }

  ElevatedButton buildElevatedButton(String buttonName, Color bgColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      onPressed: () {
        if (buttonName == "Reset") {
          showConfirmationDialog(context, () {
            setState(() {
              widget.product.clear();
              _createController.totalSubtotals.value = 0;
            });
          }, "Are you sure you want to reset Sales item?");
        } else if (buttonName == "Save Return Sales") {
          List<Map<String, dynamic>> transformedProducts =
              transformProducts(widget.product);
          _createController.createSalesReturn(
              product: transformedProducts, userId: userInfo.user['user_id']);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(
          buttonName,
          style: GoogleFonts.raleway(
            color: ColorSchema.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(
      BuildContext context, Function onYesPressed, subText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: ColorSchema.white,
        title: Text(
          "Confirmation",
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        content: Text(
          subText,
          style: GoogleFonts.nunito(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              onYesPressed();
              Navigator.of(context).pop();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }
}
