import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/data/models/products_model/products_enum.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProductScreen extends StatefulWidget {
  final dynamic product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final UpdateProductController _createController = UpdateProductController();
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
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Edit Product",
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
        const SizedBox(
          height: 20,
        ),
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
                        ColorSchema.blue.withOpacity(0.05).withOpacity(0.3),
                    radius: 60,
                    backgroundImage: _createController.selectedFile.value !=
                            null
                        ? FileImage(_createController.selectedFile.value!)
                            as ImageProvider<Object>
                        : widget.product['image'].isNotEmpty
                            ? NetworkImage(widget.product['image'])
                                as ImageProvider<Object>
                            : const AssetImage("assets/images/logo/dell.png")
                                as ImageProvider<Object>,
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
        Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                    widget.product['title'],
                    TextInputType.text,
                    _createController.title.value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Obx(() => Expanded(
                            child: buildOptionalInputTextField(
                              widget.product['product_code'],
                              TextInputType.number,
                              _createController.productCode.value,
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
                          "Price ${settings['currency_symbol']}${widget.product['price']}",
                          TextInputType.number,
                          _createController.price.value,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: buildOptionalInputTextField(
                          "Quantity ${widget.product['quantity']}",
                          TextInputType.number,
                          _createController.quantity.value,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdownField(
                            hintText: "Dis ${widget.product['discount_type']}",
                            dropdownItems: productDiscountEnum
                                .map((item) => item["title"] as String)
                                .toList(),
                            onSelectedValueChanged: (value) {
                              _createController.discountType.value = value;
                            }),
                      ),
                      const SizedBox(width: 10),
                      Obx(() =>
                          _createController.discountType.value == 'Fixed' ||
                                  _createController.discountType.value == ""
                              ? Expanded(
                                  child: buildOptionalInputTextField(
                                      "Discount ${settings['currency_symbol']}${widget.product['discount']}",
                                      TextInputType.number,
                                      _createController.discount.value),
                                )
                              : Expanded(
                                  child: buildOptionalInputTextField(
                                      "Discount ${widget.product['discount']} %",
                                      TextInputType.number,
                                      _createController.discount.value),
                                ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdownField(
                            hintText: "Tax ${widget.product['tax_type']}",
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
                                  "Tax ${settings['currency_symbol']}${widget.product['tax']}",
                                  TextInputType.number,
                                  _createController.tax.value),
                            )
                          : Expanded(
                              child: CustomDropdownField(
                                  hintText: "Tax ${widget.product['tax']} %",
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
                            hintText: "Color ${widget.product['color']}",
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
                            hintText: "Size ${widget.product['sizeTitle']}",
                            dropdownItems: _dependencyController.sizeVariantList
                                .map((item) => item["name"] as String)
                                .toList(),
                            onSelectedValueChanged: (value) {
                              _createController.sizeValue.value = value;
                              _createController.sizeID.value =
                                  _dependencyController
                                      .sizeVariantList
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
                              hintText: "Ctg. ${widget.product['categories']}",
                              dropdownItems: categoryController.allCategoryList
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
                              hintText: "Br. ${widget.product['Brand']}",
                              dropdownItems: _dependencyController.brandList
                                  .map((item) => item["title"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.brandValue.value = value;
                                _createController.brandID.value =
                                    _dependencyController.brandList.firstWhere(
                                        (item) => item["title"] == value)["id"];
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
                                hintText: "No Supplier",
                                dropdownItems: const ['No Supplier Found'],
                                onSelectedValueChanged: (value) {})
                            : CustomDropdownField(
                                hintText: "Slr. ${widget.product['supplier']}",
                                dropdownItems: _dependencyController
                                    .suppliersList
                                    .map((item) => item["title"] as String)
                                    .toList(),
                                onSelectedValueChanged: (value) {
                                  _createController.supplierValue.value = value;
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
                            hintText: "${widget.product['tax_method']}",
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
                              hintText: "Type ${widget.product['type']}",
                              dropdownItems: _dependencyController.typesList
                                  .map((item) => item["title"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.typeValue.value = value;
                                _createController.typeID.value =
                                    _dependencyController.typesList.firstWhere(
                                        (item) => item["title"] == value)["id"];
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
                          setState(() {
                            _createController.isFeatured.value = value!;
                          });
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
                          setState(() {
                            _createController.isPromotionalSale.value = value!;
                          });
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
                                    controller: _createController.endDate.value,
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
                        checkValidation: _createProduct, buttonName: "Update"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _createProduct() {
    if (_formKey.currentState!.validate()) {
      _createController.updateProduct(widget.product);
    }
  }
}
