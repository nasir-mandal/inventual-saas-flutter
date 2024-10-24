import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/country/country_controller.dart';
import 'package:inventual_saas/src/business_logic/warehouse/warehouse_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UpdateWarehouseSection extends StatefulWidget {
  final dynamic warehouse;
  const UpdateWarehouseSection({super.key, required this.warehouse});
  @override
  State<UpdateWarehouseSection> createState() => _UpdateWarehouseSectionState();
}

class _UpdateWarehouseSectionState extends State<UpdateWarehouseSection> {
  final _formKey = GlobalKey<FormState>();
  final UpdateWarehouseController _createController =
      UpdateWarehouseController();
  final CountryController countryController = CountryController();

  @override
  void initState() {
    countryController.fetchAllCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: ColorSchema.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Edit Warehouse",
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
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => CustomDropdownField(
                        hintText:
                            "Country : ${widget.warehouse['country_name']}",
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
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "Warehouse : ${widget.warehouse['title']}",
                      TextInputType.text,
                      _createController.name.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "Phone : ${widget.warehouse['phone']}",
                      TextInputType.number,
                      _createController.phone.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "Email : ${widget.warehouse['email']}",
                      TextInputType.text,
                      _createController.email.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "City : ${widget.warehouse['city']}",
                      TextInputType.text,
                      _createController.city.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "Zip Code : ${widget.warehouse['zip_code']}",
                      TextInputType.text,
                      _createController.zipCode.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "Address : ${widget.warehouse['address']}",
                      TextInputType.text,
                      _createController.address.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                      "Description : ${widget.warehouse['description']}",
                      TextInputType.text,
                      _createController.description.value),
                  const SizedBox(
                    height: 20,
                  ),
                  buildFromSubmitButton(
                    checkValidation: _create,
                    buttonName: "Update Warehouse",
                  ),
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
      _createController.updateWarehouse(widget.warehouse);
    }
  }
}
