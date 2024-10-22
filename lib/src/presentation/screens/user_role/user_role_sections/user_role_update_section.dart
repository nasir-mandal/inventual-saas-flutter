import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/roles/roles_controller.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class UserRoleUpdateSection extends StatefulWidget {
  final dynamic user;

  const UserRoleUpdateSection({super.key, required this.user});

  @override
  State<UserRoleUpdateSection> createState() => _UserRoleUpdateSectionState();
}

class _UserRoleUpdateSectionState extends State<UserRoleUpdateSection> {
  final _formKey = GlobalKey<FormState>();
  final RoleController _createController = RoleController();
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
                  "Edit User Role",
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
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: buildInputTextField(
                              widget.user['title'],
                              TextInputType.text,
                              _createController.name.value,
                              "Role Is Required"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: buildFromSubmitButton(
                                checkValidation: _createRole,
                                buttonName: "Submit"),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      ],
    );
  }

  _createRole() {
    if (_formKey.currentState!.validate()) {
      _createController.updateRole(widget.user);
    }
  }
}
