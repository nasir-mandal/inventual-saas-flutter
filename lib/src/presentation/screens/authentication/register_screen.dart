import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/people/user/user_controller.dart';
import 'package:inventual/src/business_logic/roles/roles_controller.dart';
import 'package:inventual/src/data/models/people_model/gender_data.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final CreateUserController _createController = CreateUserController();
  final RoleController roleController = RoleController();
  List<String> genderItems = ["Male", "Gender"];
  bool _isPasswordHidden = true;

  late Map<String, dynamic> settings = {};

  @override
  void initState() {
    roleController.fetchAllRole();
    super.initState();
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("settings");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorSchema.white70,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: ColorSchema.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ColorSchema.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  settings['site_logo'] != null &&
                          settings['site_logo'].isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder: "assets/images/gif/loading.gif",
                          image: settings['site_logo'],
                          width: MediaQuery.of(context).size.width * 0.40,
                        )
                      : Image.asset(
                          "assets/images/logo/logo.png",
                          width: MediaQuery.of(context).size.width * 0.30,
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: firstName("First Name", TextInputType.name),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: lastName("Last name", TextInputType.name),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: buildUserNameField(
                              "Username", TextInputType.name),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: buildEmailField(
                              "Email", TextInputType.emailAddress),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: buildPhoneField("Phone", TextInputType.phone),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Obx(() => CustomDropdownField(
                              hintText: "Select Role",
                              dropdownItems: roleController.roleList
                                  .map((item) => item["title"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.roleValue.value = value;
                                _createController.roleID.value =
                                    roleController.roleList.firstWhere(
                                        (item) => item["title"] == value)["id"];
                              })),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomDropdownField(
                              hintText: "Select Gender",
                              dropdownItems: genderData
                                  .map((item) => item["title"] as String)
                                  .toList(),
                              onSelectedValueChanged: (value) {
                                _createController.genderIDValue.value = value;
                                _createController.genderID.value =
                                    genderData.firstWhere(
                                        (item) => item["title"] == value)["id"];
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: buildPasswordField("Password"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildFromSubmitButton(
                      checkValidation: _create, buttonName: "Register"),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            child: Divider(
                          color: ColorSchema.borderColor,
                          thickness: 0.7,
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "or",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: ColorSchema.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                            child: Divider(
                          color: ColorSchema.borderColor,
                          thickness: 0.7,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: ColorSchema.grey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.login);
                        },
                        child: Text(
                          "Log In",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: ColorSchema.primaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField firstName(String hint, TextInputType keyboardType) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "First name";
        }
        return null;
      },
      controller: _createController.firstName.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        suffixIcon: const Icon(
          Icons.account_circle,
          color: ColorSchema.borderColor,
          size: 20,
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: ColorSchema.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: keyboardType,
    );
  }

  TextFormField lastName(String hint, TextInputType keyboardType) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Last name";
        }
        return null;
      },
      controller: _createController.lastName.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        suffixIcon: const Icon(
          Icons.account_circle,
          color: ColorSchema.borderColor,
          size: 20,
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: ColorSchema.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: keyboardType,
    );
  }

  TextFormField buildUserNameField(String hint, TextInputType keyboardType) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your username";
        }
        return null;
      },
      controller: _createController.username.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        suffixIcon: const Icon(
          Icons.account_circle,
          color: ColorSchema.borderColor,
          size: 20,
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: ColorSchema.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: keyboardType,
    );
  }

  TextFormField buildEmailField(String hint, TextInputType keyboardType) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your email address";
        }
        final emailRegEx = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
        if (!emailRegEx.hasMatch(value)) {
          return "Enter your valid email address";
        }
        return null;
      },
      controller: _createController.email.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        suffixIcon: const Icon(
          Icons.email_rounded,
          color: ColorSchema.borderColor,
          size: 20,
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: ColorSchema.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: keyboardType,
    );
  }

  TextFormField buildPhoneField(String hint, TextInputType keyboardType) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your Phone";
        }
        return null;
      },
      controller: _createController.phone.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        suffixIcon: const Icon(
          Icons.phone,
          color: ColorSchema.borderColor,
          size: 20,
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
            textStyle: const TextStyle(
                color: ColorSchema.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: keyboardType,
    );
  }

  Widget buildPasswordField(String hint) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your password";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
      controller: _createController.password.value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
            textStyle: const TextStyle(
                color: ColorSchema.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: ColorSchema.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordHidden = !_isPasswordHidden;
            });
          },
          icon: Icon(
            _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            color: ColorSchema.borderColor,
          ),
        ),
      ),
      obscureText: _isPasswordHidden,
    );
  }

  _create() async {
    if (_formKey.currentState!.validate()) {
      bool registerSuccess = await _createController.createUser();
      if (registerSuccess) {
        Get.off(AppRoutes.login);
      }
    }
  }
}
