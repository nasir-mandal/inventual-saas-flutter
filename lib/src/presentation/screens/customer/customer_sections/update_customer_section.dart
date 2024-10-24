import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/country/country_controller.dart';
import 'package:inventual_saas/src/business_logic/people/customer/customer_controller.dart';
import 'package:inventual_saas/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UpdateCustomerSection extends StatefulWidget {
  final dynamic customer;

  const UpdateCustomerSection({super.key, required this.customer});

  @override
  State<UpdateCustomerSection> createState() => _UpdateCustomerSectionState();
}

class _UpdateCustomerSectionState extends State<UpdateCustomerSection> {
  final _formKey = GlobalKey<FormState>();
  final UpdateCustomerController _createController = UpdateCustomerController();
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Edit Customer",
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "First Name : ${widget.customer['first_name']}",
                    TextInputType.text,
                    _createController.firstName.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "Last Name : ${widget.customer['last_name']}",
                    TextInputType.text,
                    _createController.lastName.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "Email : ${widget.customer['email']}",
                    TextInputType.text,
                    _createController.email.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "Phone : ${widget.customer['phone']}",
                    TextInputType.text,
                    _createController.phone.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "City : ${widget.customer['city']}",
                    TextInputType.text,
                    _createController.city.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "Zip Code : ${widget.customer['zip_code']}",
                    TextInputType.text,
                    _createController.zipCode.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "Reward Point : ${widget.customer['reward']}",
                    TextInputType.text,
                    _createController.rewardPoint.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    "Address : ${widget.customer['address']}",
                    TextInputType.text,
                    _createController.address.value,
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => CustomDropdownField(
                      hintText: "Category : ${widget.customer['category']}",
                      dropdownItems: categoryController.dynamicCategoryList
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.customerCategoryValue.value = value;
                        _createController.customerCategoryID.value =
                            categoryController.dynamicCategoryList.firstWhere(
                                (item) => item["title"] == value)["id"];
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => CustomDropdownField(
                      hintText: "Country : ${widget.customer['country']}",
                      dropdownItems: countryController.countryList
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.countryValue.value = value;
                        _createController.countryID.value = countryController
                            .countryList
                            .firstWhere((item) => item["title"] == value)["id"];
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildFromSubmitButton(
                    checkValidation: _create,
                    buttonName: "Update Customer",
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _create() {
    if (_formKey.currentState!.validate()) {
      _createController.updateCustomer(widget.customer);
    }
  }
}
