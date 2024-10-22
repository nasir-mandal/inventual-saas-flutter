import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/business_logic/people/user/user_controller.dart';
import 'package:inventual/src/business_logic/roles/roles_controller.dart';
import 'package:inventual/src/data/models/people_model/gender_data.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class AddUserMainScreen extends StatefulWidget {
  const AddUserMainScreen({super.key});

  @override
  State<AddUserMainScreen> createState() => _AddUserMainScreenState();
}

class _AddUserMainScreenState extends State<AddUserMainScreen> {
  final _formKey = GlobalKey<FormState>();
  final CreateUserController _createController = CreateUserController();
  final RoleController roleController = RoleController();
  List<String> genderItems = ["Male", "Gender"];

  @override
  void initState() {
    roleController.fetchAllRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Add New User"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: ColorSchema.white70,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
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
                          backgroundImage: _createController
                                      .selectedFile.value !=
                                  null
                              ? FileImage(_createController.selectedFile.value!)
                              : const AssetImage(
                                      "assets/images/avatar/placeholder-user.png")
                                  as ImageProvider,
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
              const SizedBox(
                height: 20,
              ),
              buildInputTextField("Enter Email Address", TextInputType.text,
                  _createController.email.value, "Email Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter User Name",
                  TextInputType.text,
                  _createController.username.value,
                  "User Name Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              buildInputTextField(
                  "Enter Password",
                  TextInputType.text,
                  _createController.password.value,
                  "Password Is Required Field"),
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
              buildInputTextField("Enter Phone", TextInputType.number,
                  _createController.phone.value, "Phone Is Required Field"),
              const SizedBox(
                height: 20,
              ),
              Obx(() => CustomDropdownField(
                  hintText: "Select Role",
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
                  hintText: "Select Gender",
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
                  checkValidation: _create, buttonName: "Create User"),
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
      _createController.createUser();
    }
  }
}
