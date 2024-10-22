import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/business_logic/country/country_controller.dart';
import 'package:inventual/src/business_logic/people/biller/create_biller_controller.dart';
import 'package:inventual/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class CreateBillerSection extends StatefulWidget {
  const CreateBillerSection({super.key});
  @override
  State<CreateBillerSection> createState() => _CreateBillerSectionState();
}

class _CreateBillerSectionState extends State<CreateBillerSection> {
  final _formKey = GlobalKey<FormState>();
  final CreateBillerController _createController = CreateBillerController();
  final CountryController countryController = CountryController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final String selectedGroupValue = "";
  @override
  void initState() {
    _dependencyController.getAllWareHouse();
    countryController.fetchAllCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          navigateName: "Create Biller",
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
              Expanded(
                child: Obx(() => GloballyDatePicker(
                      labelText: "Date",
                      hintText: "MM/DD/YYYY",
                      controller: _createController.date.value,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => CustomDropdownField(
                  hintText: "Select Ware House",
                  dropdownItems: _dependencyController.wareHouseList
                      .map((item) => item["title"] as String)
                      .toList(),
                  onSelectedValueChanged: (value) {
                    _createController.wareHouseValue.value = value;
                    _createController.wareHouseID.value = _dependencyController
                        .wareHouseList
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
              buildInputTextField("Enter First Name", TextInputType.text,
                  _createController.firstName.value, "First Name Is Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Last Name", TextInputType.text,
                  _createController.lastName.value, "First Last Is Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Email", TextInputType.text,
                  _createController.email.value, "Email Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Phone", TextInputType.text,
                  _createController.phone.value, "Phone Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter City", TextInputType.text,
                  _createController.city.value, "City Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Zip Code", TextInputType.text,
                  _createController.zipCode.value, "Zip Code Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "NID Or Passport Number",
                  TextInputType.number,
                  _createController.nidOrPassportNumber.value,
                  "NID Or Passport Number Required"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter Biller Code",
                  TextInputType.text,
                  _createController.billerCode.value,
                  "Biller Code Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Address", TextInputType.text,
                  _createController.address.value, "Address Is Required"),
              const SizedBox(
                height: 20,
              ),
              buildFromSubmitButton(
                  checkValidation: _create, buttonName: "Create Biller"),
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
      _createController.createBiller();
    }
  }
}
