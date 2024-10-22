import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/business_logic/country/country_controller.dart';
import 'package:inventual/src/business_logic/people/supplier/create_supplier_controller.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class CreateSupplierSection extends StatefulWidget {
  const CreateSupplierSection({super.key});
  @override
  State<CreateSupplierSection> createState() => _CreateSupplierSectionState();
}

class _CreateSupplierSectionState extends State<CreateSupplierSection> {
  final _formKey = GlobalKey<FormState>();
  final CreateSupplierController _createController = CreateSupplierController();
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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          navigateName: "Create Supplier",
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: ColorSchema.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter First Name",
                  TextInputType.text,
                  _createController.firstName.value,
                  "First Name Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter Last Name",
                  TextInputType.text,
                  _createController.lastName.value,
                  "Last Name Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Email", TextInputType.text,
                  _createController.email.value, "Email Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Phone", TextInputType.text,
                  _createController.phone.value, "Phone Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              Obx(() => CustomDropdownField(
                  hintText: "Select Country",
                  dropdownItems: countryController.countryList
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.countryValue.value = value;
                    _createController.countryID.value = countryController
                        .countryList
                        .firstWhere((item) => item["title"] == value)["id"];
                  })),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter City", TextInputType.text,
                  _createController.city.value, "City Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter Supplier Code",
                  TextInputType.text,
                  _createController.supplierCode.value,
                  "Supplier Code Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Zip Code",
                  TextInputType.text,
                  _createController.zipCode.value,
                  "Zip Code Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              Obx(() => CustomDropdownField(
                  hintText: "Select Company",
                  dropdownItems: productDependencyController.companyList
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.companyValue.value = value;
                    _createController.companyID.value =
                        productDependencyController.companyList
                            .firstWhere((item) => item["title"] == value)["id"];
                  })),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Address", TextInputType.text,
                  _createController.address.value, "Address Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildFromSubmitButton(
                  checkValidation: _create, buttonName: "Create Supplier"),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  _create() {
    if (_formKey.currentState!.validate()) {
      _createController.createSupplier();
    }
  }
}
