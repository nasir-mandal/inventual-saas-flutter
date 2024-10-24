import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:inventual_saas/src/business_logic/country/country_controller.dart';
import 'package:inventual_saas/src/business_logic/people/biller/create_biller_controller.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/date_picker_section/globally_date_picker.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UpdateBillerSection extends StatefulWidget {
  final dynamic biller;
  const UpdateBillerSection({super.key, required this.biller});
  @override
  State<UpdateBillerSection> createState() => _UpdateBillerSectionState();
}

class _UpdateBillerSectionState extends State<UpdateBillerSection> {
  final UpdateBillerController _createController = UpdateBillerController();
  final _formKey = GlobalKey<FormState>();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final CountryController countryController = CountryController();

  @override
  void initState() {
    _dependencyController.getAllWareHouse();
    countryController.fetchAllCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(widget.biller['date_of_join']);
    String formattedDate = DateFormat('M/d/yyyy').format(parsedDate);

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
                  "Edit Biller",
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
              ),
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
                    Obx(() => GloballyDatePicker(
                          labelText: "Date",
                          hintText: formattedDate,
                          controller: _createController.date.value,
                        )),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdownField(
                          hintText: "Warehouse : ${widget.biller['warehouse']}",
                          dropdownItems: _dependencyController.wareHouseList
                              .map((item) => item["title"] as String)
                              .toList(),
                          onSelectedValueChanged: (value) {
                            _createController.wareHouseValue.value = value;
                            _createController.wareHouseID.value =
                                _dependencyController.wareHouseList.firstWhere(
                                    (item) => item["title"] == value)["id"];
                          },
                        )),
                    const SizedBox(height: 20),
                    Obx(() => CustomDropdownField(
                          hintText: "Country : ${widget.biller['country']}",
                          dropdownItems: countryController.countryList
                              .map((item) => item["title"] as String)
                              .toList(),
                          onSelectedValueChanged: (value) {
                            _createController.countryValue.value = value;
                            _createController.countryID.value =
                                countryController.countryList.firstWhere(
                                    (item) => item["title"] == value)["id"];
                          },
                        )),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "First name : ${widget.biller['first_name']}",
                      TextInputType.text,
                      _createController.firstName.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "Last name : ${widget.biller['last_name']}",
                      TextInputType.text,
                      _createController.lastName.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "Email : ${widget.biller['email']}",
                      TextInputType.text,
                      _createController.email.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "Phone : ${widget.biller['phone']}",
                      TextInputType.text,
                      _createController.phone.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "City : ${widget.biller['city']}",
                      TextInputType.text,
                      _createController.city.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                        "Zip code : ${widget.biller['zip_code']}",
                        TextInputType.text,
                        _createController.zipCode.value),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "NID or Passport : ${widget.biller['nid_passport_number']}",
                      TextInputType.number,
                      _createController.nidOrPassportNumber.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "Biller Code : ${widget.biller['biller_code']}",
                      TextInputType.text,
                      _createController.billerCode.value,
                    ),
                    const SizedBox(height: 20),
                    buildOptionalInputTextField(
                      "Address : ${widget.biller['address']}",
                      TextInputType.text,
                      _createController.address.value,
                    ),
                    const SizedBox(height: 20),
                    buildFromSubmitButton(
                      checkValidation: _create,
                      buttonName: "Update Biller",
                    ),
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
      _createController.updateBiller(widget.biller);
    }
  }
}
