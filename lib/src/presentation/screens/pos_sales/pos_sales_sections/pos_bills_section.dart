import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/authentication.dart';
import 'package:inventual/src/business_logic/pos_sale/create_payment_controller.dart';
import 'package:inventual/src/business_logic/pos_sale/create_sale.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/data/models/dropdown.dart';
import 'package:inventual/src/presentation/screens/pos_sales/pos_sales_main_screen.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/presentation/widgets/text_field/text_field_section.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosBillsSection extends StatefulWidget {
  final dynamic product;
  const PosBillsSection({super.key, required this.product});
  @override
  State<PosBillsSection> createState() => _PosBillsSectionState();
}

class _PosBillsSectionState extends State<PosBillsSection> {
  final _formKey = GlobalKey<FormState>();
  final CreateSaleController _createController = CreateSaleController();
  final CreatePaymentController createPaymentController =
      CreatePaymentController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final UserController userInfo = UserController();
  String customerSelectedValue = "";
  String billerSelectedValue = "";
  String warehouseSelectedValue = "";
  String paymentTypeSelectionValue = "";
  List<String> paymentTypeItems = ["Card", "Cash", "Bank"];
  late List<int> quantities;
  late List<double> subtotals;
  late Map<String, dynamic> settings = {};

  @override
  void initState() {
    super.initState();
    userInfo.loadUser();
    _dependencyController.getAllWareHouse();
    _dependencyController.getAllCustomers();
    _dependencyController.getAllBillers();
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
          child: CustomAppBar(navigateName: "POS Bills")),
      body: Container(
        color: ColorSchema.white70,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => CustomDropdownField(
                  hintText: "Select Customer",
                  dropdownItems: _dependencyController.customerList
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.customerValue.value = value;
                    _createController.customerID.value = _dependencyController
                        .customerList
                        .firstWhere((item) => item["title"] == value)["id"];
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => CustomDropdownField(
                  hintText: "Biller Code",
                  dropdownItems: _dependencyController.billersList
                      .map((item) => item["biller_code"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.billerValue.value = value;
                    _createController.billerID.value =
                        _dependencyController.billersList.firstWhere(
                            (item) => item["biller_code"] == value)["id"];
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.product.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "POS Products Item",
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
                          color: ColorSchema.grey.withOpacity(0.2)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                        buttonName: "Go POS",
                        onPressed: () {
                          Get.off(const POSSalesMainScreen());
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
                            color: ColorSchema.borderColor, width: 0.5)),
                    columnSpacing: 35,
                    headingRowHeight: 50,
                    dataRowHeight: 70,
                    headingRowColor: MaterialStateProperty.all(
                        ColorSchema.grey.withOpacity(0.1)),
                    dividerThickness: 0,
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
                            DataCell(
                              Text(
                                "${widget.product[index]["tax"]} ${widget.product[index]["tax_type"] == "Percent" ? "%" : settings['currency_symbol']}",
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(),
                                ),
                              ),
                            ),
                            DataCell(Text(
                                "${widget.product[index]["discount"]} ${widget.product[index]["discount_type"] == "Percent" ? "%" : settings['currency_symbol']}",
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
                  buildElevatedButton("Payment", ColorSchema.primaryColor)
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
              "${settings['currency_symbol']}${_createController.totalAmount.toStringAsFixed(2)}",
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
          }, "Are you sure you want to reset POS item?");
        } else if (buttonName == "Payment") {
          if (_createController.wareHouseID.value == 0 ||
              _createController.customerID.value == 0 ||
              _createController.billerID.value == 0) {
            Get.snackbar(
              "Error",
              "Selectable Field's Missing",
              backgroundColor: ColorSchema.danger.withOpacity(0.5),
              colorText: ColorSchema.white,
              animationDuration: const Duration(milliseconds: 800),
            );
          } else {
            List<Map<String, dynamic>> transformedProducts =
                transformProducts(widget.product);
            _createController.createSale(
                product: transformedProducts,
                userId: userInfo.user['user_id'],
                paymentPage: 'payment');
            buildPaymentModal(
                context, paymentTypeSelectionValue, paymentTypeItems);
          }
        } else if (buttonName == "Save Sale") {
          List<Map<String, dynamic>> transformedProducts =
              transformProducts(widget.product);
          _createController.createSale(
              product: transformedProducts,
              userId: userInfo.user['user_id'],
              paymentPage: '');
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
        fillColor: ColorSchema.lightGray,
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
        child: Form(
          key: _formKey,
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
                              color: ColorSchema.lightBlack,
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
                  TextFormField(
                    controller:
                        createPaymentController.paidAmount.value as dynamic,
                    onChanged: (value) {
                      createPaymentController.calculateSubtotals(
                          payableAmount: _createController.payableAmount.value);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      fillColor: ColorSchema.white,
                      filled: true,
                      hintText: "Paid Amount",
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => TextFieldSection(
                      hint:
                          "Payable Amount ${_createController.payableAmount.value.toStringAsFixed(2)}",
                      inputType: TextInputType.number)),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    final changeAmount =
                        createPaymentController.change.value.toStringAsFixed(2);
                    final dueAmount =
                        createPaymentController.due.value.toStringAsFixed(2);

                    if (createPaymentController.change.value > 0) {
                      return TextFieldSection(
                        hint: "Change Amount $changeAmount",
                        inputType: TextInputType.number,
                      );
                    } else {
                      return TextFieldSection(
                        hint: "Due Amount $dueAmount",
                        inputType: TextInputType.number,
                      );
                    }
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDropdownField(
                      hintText: "Payment Type",
                      dropdownItems: paymentType
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        createPaymentController.paymentTypeValue.value = value;
                        createPaymentController.paymentTypeId.value =
                            paymentType.firstWhere(
                                (item) => item["title"] == value)["id"];
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    if (createPaymentController.paymentTypeValue.value ==
                        "Bkash") {
                      return buildInputTextField(
                          "Enter Bkash Trx Number",
                          TextInputType.text,
                          createPaymentController.bkashNumber.value,
                          "City Is Required Field");
                    } else {
                      return const SizedBox();
                    }
                  }),
                  Obx(() {
                    if (createPaymentController.paymentTypeValue.value ==
                        "Card") {
                      return buildInputTextField(
                          "Enter Card Number",
                          TextInputType.text,
                          createPaymentController.cardNumber.value,
                          "City Is Required Field");
                    } else {
                      return const SizedBox();
                    }
                  }),
                  Obx(() {
                    if (createPaymentController.paymentTypeValue.value ==
                            "Card" ||
                        createPaymentController.paymentTypeValue.value ==
                            "Bkash") {
                      return const SizedBox(
                        height: 20,
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                  buildOptionalInputTextField("Sale Note", TextInputType.text,
                      createPaymentController.remark.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildFromSubmitButton(
                      checkValidation: _create, buttonName: "Pay Now"),
                ],
              ),
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

  _create() {
    if (_formKey.currentState!.validate()) {
      createPaymentController.createPayment(
          orderId: _createController.orderID.value,
          payableAmount: _createController.payableAmount.value);
    }
  }
}
