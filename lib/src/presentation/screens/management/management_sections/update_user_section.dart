import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/people/user/user_controller.dart';
import 'package:inventual_saas/src/business_logic/roles/roles_controller.dart';
import 'package:inventual_saas/src/data/models/people_model/gender_data.dart';
import 'package:inventual_saas/src/presentation/screens/management/management_main_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class UpdateUserSection extends StatefulWidget {
  final dynamic user;
  const UpdateUserSection({super.key, required this.user});
  @override
  State<UpdateUserSection> createState() => _UpdateUserSectionState();
}

class _UpdateUserSectionState extends State<UpdateUserSection> {
  final _formKey = GlobalKey<FormState>();
  final UpdateUserController _createController = UpdateUserController();
  final RoleController roleController = RoleController();

  @override
  void initState() {
    roleController.fetchAllRole();
    super.initState();
  }

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
                  "Edit User",
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
        GestureDetector(
          onTap: () async {
            await _createController.pickImage();
          },
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Obx(() {
                  return CircleAvatar(
                    backgroundColor: ColorSchema.blue.withOpacity(0.05),
                    radius: 60,
                    backgroundImage: _createController.selectedFile.value !=
                            null
                        ? FileImage(_createController.selectedFile.value!)
                            as ImageProvider<Object>
                        : widget.user['image'].isNotEmpty
                            ? NetworkImage(widget.user['image'])
                                as ImageProvider<Object>
                            : const AssetImage("assets/images/logo/dell.png")
                                as ImageProvider<Object>,
                  );
                }),
                const Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: ColorSchema.primaryColor,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: ColorSchema.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Container(
            color: ColorSchema.white70,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                    widget.user['email'],
                    TextInputType.text,
                    _createController.email.value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                    widget.user['username'],
                    TextInputType.text,
                    _createController.username.value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                    widget.user['first_name'],
                    TextInputType.text,
                    _createController.firstName.value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                    widget.user['last_name'],
                    TextInputType.text,
                    _createController.lastName.value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildOptionalInputTextField(
                    widget.user['phone'],
                    TextInputType.number,
                    _createController.phone.value,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => CustomDropdownField(
                      hintText: "Current Role ${widget.user['role']}",
                      dropdownItems: roleController.roleList
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.roleValue.value = value;
                        _createController.roleID.value = roleController.roleList
                            .firstWhere((item) => item["title"] == value)["id"];
                      })),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomDropdownField(
                      hintText: "Current Gender ${widget.user['gender']}",
                      dropdownItems: genderData
                          .map((item) => item["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _createController.genderIDValue.value = value;
                        _createController.genderID.value = genderData
                            .firstWhere((item) => item["title"] == value)["id"];
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  buildFromSubmitButton(
                      checkValidation: _create, buttonName: "Update User"),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _create() async {
    if (_formKey.currentState!.validate()) {
      bool updateUser = await _createController.updateUserInfo(widget.user);
      if (updateUser) {
        Get.off(const ManagementMainScreen());
      }
    }
  }
}
