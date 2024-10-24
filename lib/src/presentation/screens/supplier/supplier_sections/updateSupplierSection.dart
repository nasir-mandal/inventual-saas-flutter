import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/country/country_controller.dart';
import 'package:inventual_saas/src/business_logic/people/supplier/create_supplier_controller.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UpdateSupplierSection extends StatefulWidget {
  final dynamic supplier;

  const UpdateSupplierSection({super.key, required this.supplier});

  @override
  State<UpdateSupplierSection> createState() => _UpdateSupplierSectionState();
}

class _UpdateSupplierSectionState extends State<UpdateSupplierSection> {
  final _formKey = GlobalKey<FormState>();
  final UpdateSupplierController _createController = UpdateSupplierController();
  final ProductDependencyController productDependencyController =
      ProductDependencyController();
  final CountryController countryController = CountryController();

  @override
  void initState() {
    productDependencyController.getAllCompany();
    countryController.fetchAllCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  "Edit Supplier",
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "First Name : ${widget.supplier['first_name']}",
                        TextInputType.text,
                        _createController.firstName.value),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Last Name : ${widget.supplier['last_name']}",
                        TextInputType.text,
                        _createController.lastName.value),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Email : ${widget.supplier['email']}",
                        TextInputType.text,
                        _createController.email.value),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Phone : ${widget.supplier['phone']}",
                        TextInputType.text,
                        _createController.phone.value),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdownField(
                        hintText:
                            "Country : ${widget.supplier['country_name']}",
                        dropdownItems: countryController.countryList
                            .map((item) => item["title"] as String)
                            .toList(),
                        onSelectedValueChanged: (value) {
                          _createController.countryValue.value = value;
                          _createController.countryID.value =
                              countryController.countryList.firstWhere(
                                  (item) => item["title"] == value)["id"];
                        })),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "City : ${widget.supplier['city']}",
                        TextInputType.text,
                        _createController.city.value),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Supplier Code : ${widget.supplier['supplier_code']}",
                        TextInputType.text,
                        _createController.supplierCode.value),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Zip Code : ${widget.supplier['zip_code']}",
                        TextInputType.text,
                        _createController.zipCode.value),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdownField(
                        hintText:
                            "Company : ${widget.supplier['company_name']}",
                        dropdownItems: productDependencyController.companyList
                            .map((item) => item["title"] as String)
                            .toList(),
                        onSelectedValueChanged: (value) {
                          _createController.companyValue.value = value;
                          _createController.companyID.value =
                              productDependencyController.companyList
                                  .firstWhere(
                                      (item) => item["title"] == value)["id"];
                        })),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Address : ${widget.supplier['address']}",
                        TextInputType.text,
                        _createController.address.value),
                    const SizedBox(height: 20),
                    buildFromSubmitButton(
                        checkValidation: _create,
                        buttonName: "Update Supplier"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _create() {
    if (_formKey.currentState!.validate()) {
      _createController.updateSupplier(widget.supplier);
    }
  }
}
