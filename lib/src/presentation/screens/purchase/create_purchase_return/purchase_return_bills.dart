import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/authentication.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/business_logic/purchase/purchase_return_controller.dart';
import 'package:inventual_saas/src/data/models/expense_model/expense_type.dart';
import 'package:inventual_saas/src/presentation/screens/purchase/create_purchase_return/create_purchase_return_main_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/dropdown_form_field_section.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/text_field_max_line_section.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseReturnBillsSection extends StatefulWidget {
  final dynamic product;

  const PurchaseReturnBillsSection({super.key, required this.product});

  @override
  State<PurchaseReturnBillsSection> createState() =>
      _PurchaseBillsSectionState();
}

class _PurchaseBillsSectionState extends State<PurchaseReturnBillsSection> {
  final CreatePurchaseReturnController _createController =
      CreatePurchaseReturnController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final UserController userInfo = UserController();
  String customerSelectedValue = "";
  String billerSelectedValue = "";
  String warehouseSelectedValue = "";
  String paymentTypeSelectionValue = "";
  late List<int> quantities;
  late List<double> subtotals;
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> taxControllers = [];
  List<TextEditingController> discountControllers = [];
  late Map<String, dynamic> settings = {};

  @override
  void initState() {
    super.initState();
    userInfo.loadUser();
    _dependencyController.getAllWareHouse();
    _dependencyController.getAllSuppliers();
    _dependencyController.getAllBillers();

    quantities = List<int>.filled(widget.product.length, 1);
    subtotals = List<double>.filled(widget.product.length, 0);

    priceControllers = List.generate(
      widget.product.length,
      (index) => TextEditingController(text: widget.product[index]['price']),
    );
    taxControllers = List.generate(
      widget.product.length,
      (index) => TextEditingController(text: widget.product[index]['tax']),
    );
    discountControllers = List.generate(
      widget.product.length,
      (index) => TextEditingController(text: widget.product[index]['discount']),
    );

    _createController.calculateSubtotals(
      product: widget.product,
      quantities: quantities,
      subtotals: subtotals,
    );
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
  }

  void _updateProductData(int index) {
    double price = double.tryParse(priceControllers[index].text) ?? 0;
    double tax = double.tryParse(taxControllers[index].text) ?? 0;
    double discount = double.tryParse(discountControllers[index].text) ?? 0;

    setState(() {
      widget.product[index]["price"] = price.toString();
      widget.product[index]["tax"] = tax.toString();
      widget.product[index]["discount"] = discount.toString();

      _createController.calculateSubtotals(
          product: widget.product,
          quantities: quantities,
          subtotals: subtotals);
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < quantities.length) {
      setState(() {
        quantities[index] = newQuantity;
        _createController.calculateSubtotals(
          product: widget.product,
          quantities: quantities,
          subtotals: subtotals,
        );
      });
    }
  }

  List<Map<String, dynamic>> transformProducts(List<dynamic> products) {
    return products.asMap().entries.map((entry) {
      int index = entry.key;
      if (index >= 0 && index < priceControllers.length) {
        var product = entry.value;
        double price = double.tryParse(priceControllers[index].text) ?? 0;
        double tax = double.tryParse(taxControllers[index].text) ?? 0;
        double discount = double.tryParse(discountControllers[index].text) ?? 0;

        return {
          "product_id": product["id"],
          "amount": price,
          "quantity": quantities[index],
          "tax_amount": tax,
          "discount": discount,
        };
      } else {
        // Handle the case where the index is out of range
        return {
          "product_id": entry.value["id"],
          "amount": 0,
          "quantity": 0,
          "tax_amount": 0,
          "discount": 0,
        };
      }
    }).toList();
  }

  void _updatePrice(int index, String value) {
    if (index >= 0 && index < priceControllers.length) {
      double price = double.tryParse(value) ?? 0;
      setState(() {
        // Update the price in the list
        widget.product[index]['price'] = price.toString();
        // Recalculate the subtotals
        _createController.calculateSubtotals(
          product: widget.product,
          quantities: quantities,
          subtotals: subtotals,
        );
      });
    }
  }

  void _updateTax(int index, String value) {
    if (index >= 0 && index < taxControllers.length) {
      double tax = double.tryParse(value) ?? 0;
      setState(() {
        // Update the tax in the list
        widget.product[index]['tax'] = tax.toString();
        // Recalculate the subtotals
        _createController.calculateSubtotals(
          product: widget.product,
          quantities: quantities,
          subtotals: subtotals,
        );
      });
    }
  }

  void _updateDiscount(int index, String value) {
    if (index >= 0 && index < discountControllers.length) {
      double discount = double.tryParse(value) ?? 0;
      setState(() {
        // Update the discount in the list
        widget.product[index]['discount'] = discount.toString();
        // Recalculate the subtotals
        _createController.calculateSubtotals(
          product: widget.product,
          quantities: quantities,
          subtotals: subtotals,
        );
      });
    }
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
  void dispose() {
    // Dispose of the controllers to prevent memory leaks.
    for (var controller in taxControllers) controller.dispose();
    for (var controller in discountControllers) controller.dispose();
    for (var controller in priceControllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(navigateName: "Return Purchase Bills")),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: buildOptionalInputTextField(
                      "Return Note",
                      TextInputType.text,
                      _createController.returnNote.value,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: buildOptionalInputTextField(
                      "Remark",
                      TextInputType.text,
                      _createController.remark.value,
                    ),
                  ),
                ],
              ),
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
                      "Return Purchase Products Item",
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
                        buttonName: "Select Items",
                        onPressed: () {
                          Get.off(const CreatePurchaseReturnMainScreen());
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
                      border:
                          Border.all(color: ColorSchema.borderColor, width: 1),
                    ),
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
                          'Price',
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
                                ),
                              ],
                            )),
                            DataCell(
                              TextField(
                                controller: priceControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Enter Price",
                                ),
                                onChanged: (value) {
                                  _updatePrice(index, value);
                                },
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: taxControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Enter Tax",
                                ),
                                onChanged: (value) {
                                  _updateTax(index, value);
                                },
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: discountControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Enter Discount",
                                ),
                                onChanged: (value) {
                                  _updateDiscount(index, value);
                                },
                              ),
                            ),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (quantities[index] > 1) {
                                      setState(() {
                                        _updateQuantity(
                                            index, quantities[index] - 1);
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: ColorSchema.borderLightBlue,
                                        width: 2,
                                      ),
                                    ),
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
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorSchema.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: ColorSchema.primaryColor,
                                        width: 2,
                                      ),
                                    ),
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
                                      quantities.removeAt(index);
                                      subtotals.removeAt(index);
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
                      color: ColorSchema.white,
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
                          borderSide: BorderSide(
                              color: ColorSchema.grey.withOpacity(0.3),
                              width: 1),
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
                  buildElevatedButton("Save Return Purchase",
                      ColorSchema.success.withOpacity(0.7)),
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
              _createController.totalSubtotals.toStringAsFixed(2),
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
          }, "Are you sure you want to reset  item?");
        } else if (buttonName == "Save Return Purchase") {
          List<Map<String, dynamic>> transformedProducts =
              transformProducts(widget.product);
          _createController.createPurchaseReturn(
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

  TextField buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
            textStyle: const TextStyle(
          color: ColorSchema.grey,
          fontWeight: FontWeight.w500,
        )),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide:
              BorderSide(color: ColorSchema.grey.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: TextInputType.number,
    );
  }

  void buildPaymentModal(BuildContext context, String paymentTypeSelectionValue,
      List<String> paymentTypeItems) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 0,
        child: Card(
          elevation: 0,
          color: ColorSchema.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Make Payment",
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: ColorSchema.grey,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: ColorSchema.red, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/icons/icon_svg/close_icon.svg",
                            width: 10,
                            color: ColorSchema.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
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
                    hint: "Change", inputType: TextInputType.number),
                const SizedBox(
                  height: 20,
                ),
                DropdownFormFieldSection(
                    label: "Payment Type",
                    hint: "Select Type",
                    items: paymentTypeItems,
                    selectionItem: paymentTypeSelectionValue),
                const SizedBox(
                  height: 20,
                ),
                const TextFieldSection(
                    hint: "Card Number", inputType: TextInputType.number),
                const SizedBox(
                  height: 20,
                ),
                const DatePicker(
                  labelText: "Expired Date",
                  hintText: "MM/DD/YYYY",
                ),
                const SizedBox(
                  height: 20,
                ),
                const TextFieldMaxLineSection(
                    labelText: "Sale Note", hintText: "Type Sales Note..."),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                      buttonName: "Pay Now", onPressed: () {}),
                )
              ],
            ),
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
