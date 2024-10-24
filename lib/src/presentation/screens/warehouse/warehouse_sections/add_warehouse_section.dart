import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual_saas/src/business_logic/country/country_controller.dart';
import 'package:inventual_saas/src/business_logic/warehouse/warehouse_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class AddWarehouseSection extends StatefulWidget {
  const AddWarehouseSection({super.key});

  @override
  State<AddWarehouseSection> createState() => _AddWarehouseSectionState();
}

class _AddWarehouseSectionState extends State<AddWarehouseSection> {
  final _formKey = GlobalKey<FormState>();
  final CreateWarehouseController _createController =
      CreateWarehouseController();

  final CountryController countryController = CountryController();

  @override
  void initState() {
    countryController.fetchAllCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          navigateName: "Add Warehouse",
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
                buildInputTextField(
                    "Enter Warehouse Name",
                    TextInputType.text,
                    _createController.name.value,
                    "Warehouse Name Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildInputTextField("Enter Phone Number", TextInputType.number,
                    _createController.phone.value, "Phone Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildInputTextField("Enter Email Number", TextInputType.text,
                    _createController.email.value, "Email Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildInputTextField("Enter City", TextInputType.text,
                    _createController.city.value, "City Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildInputTextField(
                    "Enter Zip Code ",
                    TextInputType.text,
                    _createController.zipCode.value,
                    "zipCode Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildInputTextField(
                    "Enter Address",
                    TextInputType.text,
                    _createController.address.value,
                    "Address Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildInputTextField(
                    "Enter Description",
                    TextInputType.text,
                    _createController.description.value,
                    "Description Is Required Field"),
                const SizedBox(
                  height: 20,
                ),
                buildFromSubmitButton(
                    checkValidation: _create, buttonName: "Create Warehouse"),
              ],
            ),
          )),
    );
  }

  _create() {
    if (_formKey.currentState!.validate()) {
      _createController.createWarehouse();
    }
  }
}
