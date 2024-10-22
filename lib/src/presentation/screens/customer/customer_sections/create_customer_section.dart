import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/business_logic/country/country_controller.dart';
import 'package:inventual/src/business_logic/people/customer/customer_controller.dart';
import 'package:inventual/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class AddCustomerSection extends StatefulWidget {
  const AddCustomerSection({super.key});
  @override
  State<AddCustomerSection> createState() => _AddCustomerSectionState();
}

class _AddCustomerSectionState extends State<AddCustomerSection> {
  final _formKey = GlobalKey<FormState>();
  final CreateCustomerController _createController = CreateCustomerController();
  final CategoryController categoryController = CategoryController();
  final CountryController countryController = CountryController();

  @override
  void initState() {
    categoryController.getAllDynamicCategory("Customer");
    countryController.fetchAllCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          navigateName: "Create Customer",
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
                  "First Last Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Customer Email", TextInputType.text,
                  _createController.email.value, "Email Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Customer Phone", TextInputType.text,
                  _createController.phone.value, "Phone Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter City", TextInputType.text,
                  _createController.city.value, "City Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Zip Code", TextInputType.text,
                  _createController.zipCode.value, "Zip Code Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter Reward Point",
                  TextInputType.text,
                  _createController.rewardPoint.value,
                  "Reward Point Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Address", TextInputType.text,
                  _createController.address.value, "Address Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              Obx(() => CustomDropdownField(
                  hintText: "Select Customer Category",
                  dropdownItems: categoryController.dynamicCategoryList
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.customerCategoryValue.value = value;
                    _createController.customerCategoryID.value =
                        categoryController.dynamicCategoryList
                            .firstWhere((item) => item["title"] == value)["id"];
                  })),
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
              buildFromSubmitButton(
                  checkValidation: _create, buttonName: "Create Customer"),
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
      _createController.createCustomer();
    }
  }
}
