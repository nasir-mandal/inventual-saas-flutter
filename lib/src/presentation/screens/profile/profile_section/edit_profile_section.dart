import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/business_logic/authentication.dart';
import 'package:inventual/src/business_logic/people/user/user_controller.dart';
import 'package:inventual/src/business_logic/roles/roles_controller.dart';
import 'package:inventual/src/data/models/people_model/gender_data.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileSection extends StatefulWidget {
  const EditProfileSection({Key? key}) : super(key: key);

  @override
  State<EditProfileSection> createState() => _EditProfileSectionState();
}

class _EditProfileSectionState extends State<EditProfileSection> {
  final _formKey = GlobalKey<FormState>();
  final UserAuthenticationController userAuthenticationController =
      UserAuthenticationController();
  final UpdateUserController _createController = UpdateUserController();
  final RoleController roleController = RoleController();
  late Map<String, dynamic> user = {};
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    loadUser().then(
      (value) {
        setState(() {
          user = value ?? {};
        });
      },
    );
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          const Divider(color: ColorSchema.white38),
          const SizedBox(height: 20),
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
                          : (user['image'] != null && user['image'].isNotEmpty)
                              ? NetworkImage(user['image'])
                                  as ImageProvider<Object>
                              : const AssetImage(
                                      "assets/images/avatar/placeholder-user.png")
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
          const SizedBox(height: 20),
          _buildForm(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      elevation: 0,
      color: ColorSchema.white60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Container(
            color: ColorSchema.white70,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    user['email'] ?? '',
                    TextInputType.text,
                    _createController.email.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    user['username'] ?? '',
                    TextInputType.text,
                    _createController.username.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    user['first_name'] ?? '',
                    TextInputType.text,
                    _createController.firstName.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    user['last_name'] ?? '',
                    TextInputType.text,
                    _createController.lastName.value,
                  ),
                  const SizedBox(height: 20),
                  buildOptionalInputTextField(
                    user['phone'] ?? '',
                    TextInputType.number,
                    _createController.phone.value,
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    hintText:
                        "Current Gender ${user['gender'] ?? 'Not Specified'}",
                    dropdownItems: genderData
                        .map((item) => item["title"] as String)
                        .toList(),
                    onSelectedValueChanged: (value) {
                      _createController.genderIDValue.value = value;
                      _createController.genderID.value = genderData.firstWhere(
                        (item) => item["title"] == value,
                        orElse: () => {"id": 0},
                      )["id"];
                    },
                  ),
                  const SizedBox(height: 20),
                  buildFromSubmitButton(
                      checkValidation: _create, buttonName: "Update Profile"),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _create() async {
    if (_formKey.currentState!.validate()) {
      bool updateUser = await _createController.updateUserInfo(user);
      if (updateUser) {
        userAuthenticationController.logOut();
        Get.offNamed(AppRoutes.login);
      }
    }
  }
}
