import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/units/unit_controller.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class UpdateUnitManagementScreen extends StatefulWidget {
  final dynamic unit;

  const UpdateUnitManagementScreen({super.key, required this.unit});

  @override
  State<UpdateUnitManagementScreen> createState() =>
      _UpdateUnitManagementScreenState();
}

class _UpdateUnitManagementScreenState
    extends State<UpdateUnitManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final UnitController createController = UnitController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    "Edit Unit",
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildOptionalInputTextField("Unit Name ${widget.unit['name']}",
                    TextInputType.text, createController.name.value),
                const SizedBox(height: 20),
                buildOptionalInputTextField(
                    "Unit Short Name ${widget.unit['unit_type']}",
                    TextInputType.text,
                    createController.unitType.value),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: buildFromSubmitButton(
                      checkValidation: _createUnit, buttonName: "Update Unit"),
                ),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _createUnit() {
    if (_formKey.currentState!.validate()) {
      createController.updateUnit(widget.unit);
    }
  }
}
