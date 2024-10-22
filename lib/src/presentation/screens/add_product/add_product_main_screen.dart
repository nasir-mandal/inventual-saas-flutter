import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/data/models/products_model/products_enum.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/loadings/products_loaddings.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductMainScreen extends StatefulWidget {
  const AddProductMainScreen({super.key});

  @override
  State<AddProductMainScreen> createState() => _AddProductMainScreenState();
}

class _AddProductMainScreenState extends State<AddProductMainScreen> {
  final _formKey = GlobalKey<FormState>();
  final CreateProductController _createController = CreateProductController();
  final CategoryController categoryController = CategoryController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  late Map<String, dynamic> settings = {};
  @override
  void initState() {
    categoryController.getAllCategory();
    _dependencyController.getProductCode();
    _dependencyController.getAllTaxPercents();
    _dependencyController.getAllBrands();
    _dependencyController.getAllColors();
    _dependencyController.getAllSize();
    _dependencyController.getAllVariants();
    _dependencyController.getAllTypes();
    _dependencyController.getAllSuppliers();
    _dependencyController.getAllWareHouse();
    _dependencyController.getAllUnit();
    super.initState();
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
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
          child: CustomAppBar(
            navigateName: "Add Product",
          )),
      body: Obx(() => _dependencyController.productCodeLoading.value
          ? const ProductListLoading()
          : Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: ColorSchema.white70,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _createController.pickImage();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Obx(() {
                              return CircleAvatar(
                                backgroundColor:
                                    ColorSchema.blue.withOpacity(0.05),
                                radius: 60,
                                backgroundImage: _createController
                                            .selectedFile.value !=
                                        null
                                    ? FileImage(
                                        _createController.selectedFile.value!)
                                    : const AssetImage(
                                            "assets/images/products/apple_device.png")
                                        as ImageProvider,
                              );
                            }),
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: ColorSchema.primaryColor,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: ColorSchema.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildInputTextField(
                        "Product Name",
                        TextInputType.text,
                        _createController.title.value,
                        "Product Name Is Required Field"),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Obx(() => Expanded(
                              child: buildOptionalWithDefaultInputTextField(
                                "product Code",
                                TextInputType.number,
                                _createController.productCode.value,
                                defaultValue: _dependencyController
                                        .productCode['product_code'] ??
                                    '',
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildOptionalInputTextField(
                            "Product Price",
                            TextInputType.number,
                            _createController.price.value,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buildOptionalInputTextField(
                            "Product Quantity",
                            TextInputType.number,
                            _createController.quantity.value,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: CustomDropdownField(
                                hintText: "Dis. Type",
                                dropdownItems: productDiscountEnum
                                    .map((item) => item["title"] as String)
                                    .toList(),
                                onSelectedValueChanged: (value) {
                                  _createController.discountType.value = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            _createController.discountType.value == 'Fixed' ||
                                    _createController.discountType.value == ""
                                ? Expanded(
                                    child: buildOptionalInputTextField(
                                        "${settings['currency_symbol']} Discount",
                                        TextInputType.number,
                                        _createController.discount.value),
                                  )
                                : Expanded(
                                    child: buildOptionalInputTextField(
                                        "Discount %",
                                        TextInputType.number,
                                        _createController.discount.value),
                                  )
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownField(
                              hintText: "Tax Type",
                              dropdownItems: productDiscountEnum
                                  .map((item) => item["title"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.taxType.value = value;
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Obx(() => _createController.taxType.value == 'Fixed' ||
                                _createController.taxType.value == ''
                            ? Expanded(
                                child: buildOptionalInputTextField(
                                    "${settings['currency_symbol']} Tax Amount",
                                    TextInputType.number,
                                    _createController.tax.value),
                              )
                            : Expanded(
                                child: CustomDropdownField(
                                    hintText: "Tax %",
                                    dropdownItems: _dependencyController
                                        .taxPercentList
                                        .map((item) => item["title"] as String)
                                        .toList(),
                                    onSelectedValueChanged: (value) {
                                      _createController.taxValue.value = value;
                                      _createController.taxId.value =
                                          _dependencyController.taxPercentList
                                              .firstWhere((item) =>
                                                  item["title"] == value)["id"];
                                    }),
                              ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => CustomDropdownField(
                              hintText: "Color Variant",
                              dropdownItems: _dependencyController
                                  .colorVariantList
                                  .map((item) => item["name"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.colorValue.value = value;
                                _createController.colorID.value =
                                    _dependencyController.colorVariantList
                                        .firstWhere((item) =>
                                            item["name"] == value)["id"];
                              })),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Obx(() => CustomDropdownField(
                              hintText: "Size Variant",
                              dropdownItems: _dependencyController
                                  .sizeVariantList
                                  .map((item) => item["name"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.sizeValue.value = value;
                                _createController.sizeID.value =
                                    _dependencyController.sizeVariantList
                                        .firstWhere((item) =>
                                            item["name"] == value)["id"];
                              })),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Obx(() => CustomDropdownField(
                                hintText: "Category",
                                dropdownItems: categoryController
                                    .allCategoryList
                                    .map((item) => item["title"] as String)
                                    .toList(),
                                onSelectedValueChanged: (value) {
                                  _createController.categoryValue.value = value;
                                  _createController.categoryID.value =
                                      categoryController.allCategoryList
                                          .firstWhere((item) =>
                                              item["title"] ==
                                              value)["category_id"];
                                }))),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Obx(() => CustomDropdownField(
                                hintText: "Select Brand",
                                dropdownItems: _dependencyController.brandList
                                    .map((item) => item["title"] as String)
                                    .toList(),
                                onSelectedValueChanged: (value) {
                                  _createController.brandValue.value = value;
                                  _createController.brandID.value =
                                      _dependencyController.brandList
                                          .firstWhere((item) =>
                                              item["title"] == value)["id"];
                                }))),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => _dependencyController
                                  .suppliersList.isEmpty
                              ? CustomDropdownField(
                                  hintText: "Supplier",
                                  dropdownItems: const ['No Supplier Found'],
                                  onSelectedValueChanged: (value) {})
                              : CustomDropdownField(
                                  hintText: "Supplier",
                                  dropdownItems: _dependencyController
                                      .suppliersList
                                      .map((item) => item["title"] as String)
                                      .toList(),
                                  onSelectedValueChanged: (value) {
                                    _createController.supplierValue.value =
                                        value;
                                    _createController.supplierID.value =
                                        _dependencyController.suppliersList
                                            .firstWhere((item) =>
                                                item["title"] == value)["id"];
                                  })),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomDropdownField(
                              hintText: "Tax Method",
                              dropdownItems: taxMethodEnum
                                  .map((item) => item["title"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.taxMethod.value = value;
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
                                hintText: "Product Type",
                                dropdownItems: _dependencyController.typesList
                                    .map((item) => item["title"] as String)
                                    .toList(),
                                onSelectedValueChanged: (value) {
                                  _createController.typeValue.value = value;
                                  _createController.typeID.value =
                                      _dependencyController.typesList
                                          .firstWhere((item) =>
                                              item["title"] == value)["id"];
                                }))),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Obx(() => CustomDropdownField(
                              hintText: "Product Unit",
                              dropdownItems: _dependencyController.unitList
                                  .map((item) => item["unit_type"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.unitValue.value = value;
                                _createController.unitId.value =
                                    _dependencyController.unitList.firstWhere(
                                        (item) =>
                                            item["unit_type"] == value)["id"];
                              })),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: ColorSchema.white,
                          activeColor: ColorSchema.primaryColor,
                          value: _createController.isFeatured.value,
                          side: MaterialStateBorderSide.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return const BorderSide(
                                  color: ColorSchema.primaryColor, width: 1);
                            }
                            return const BorderSide(
                                color: ColorSchema.grey, width: 1);
                          }),
                          onChanged: (value) {
                            _createController.isFeatured.value = value!;
                          },
                        ),
                        Text(
                          "Add Featured",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: ColorSchema.lightBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: ColorSchema.white,
                          activeColor: ColorSchema.primaryColor,
                          value: _createController.isPromotionalSale.value,
                          side: MaterialStateBorderSide.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return const BorderSide(
                                  color: ColorSchema.primaryColor, width: 1);
                            }
                            return const BorderSide(
                                color: ColorSchema.grey, width: 1);
                          }),
                          onChanged: (value) {
                            _createController.isPromotionalSale.value = value!;
                          },
                        ),
                        Text(
                          "Add Promotional Sale",
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: ColorSchema.lightBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => _createController.isPromotionalSale.value == true
                        ? Row(
                            children: [
                              Expanded(
                                child: Obx(() => GloballyDatePicker(
                                      labelText: "Start Date",
                                      hintText: "MM/DD/YYYY",
                                      controller:
                                          _createController.startDate.value,
                                    )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Obx(() => GloballyDatePicker(
                                      labelText: "End Date",
                                      hintText: "MM/DD/YYYY",
                                      controller:
                                          _createController.endDate.value,
                                    )),
                              ),
                            ],
                          )
                        : const SizedBox()),
                    Obx(() => _createController.isPromotionalSale.value == true
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox()),
                    Obx(() => _createController.isPromotionalSale.value == true
                        ? Row(
                            children: [
                              Expanded(
                                child: buildOptionalInputTextField(
                                  "Promotional Price",
                                  TextInputType.number,
                                  _createController.promoPrice.value,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox()),
                    Obx(() => _createController.isPromotionalSale.value == true
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox()),
                    SizedBox(
                      width: double.maxFinite,
                      child: buildFromSubmitButton(
                          checkValidation: _createProduct,
                          buttonName: "Submit"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  _createProduct() {
    if (_formKey.currentState!.validate()) {
      _createController.createProduct();
    }
  }
}
