import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/authentication.dart';
import 'package:inventual/src/business_logic/settings_controller.dart';
import 'package:inventual/src/presentation/widgets/loadings/dashboard_loading.dart';
import 'package:inventual/src/routes/app_routes.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserAuthenticationController _controller =
      UserAuthenticationController();
  final SettingsController settingsController = SettingsController();
  bool _isChecked = false;
  bool _isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> settings = {};
  @override
  void initState() {
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
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const DashboardLoading();
        } else {
          return _buildLoginForm(context);
        }
      }),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
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
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: buildTextField(
                            "User Name", TextInputType.emailAddress),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: buildPasswordField("Password"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isChecked = !_isChecked;
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Checkbox(
                              activeColor: ColorSchema.primaryColor,
                              side: const BorderSide(
                                color: ColorSchema.borderColor,
                              ),
                              splashRadius: 0,
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                          ),
                          Text(
                            "Remember me",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              color: ColorSchema.grey,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildElevatedButton(),
                const SizedBox(height: 20),
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
                      const SizedBox(width: 10),
                      Text(
                        "or",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: ColorSchema.grey),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Divider(
                        color: ColorSchema.borderColor,
                        thickness: 0.7,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorSchema.grey),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: Text(
                        "Register",
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
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorSchema.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: _login,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40),
        child: Text(
          "Log In",
          style: GoogleFonts.raleway(
            color: ColorSchema.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  _login() async {
    if (_formKey.currentState!.validate()) {
      bool loginSuccess = await _controller.login(context);
      if (loginSuccess) {
        settingsController.loadSettings();
      }
    }
  }

  TextFormField buildTextField(String hint, TextInputType keyboardType) {
    return TextFormField(
      controller: _controller.username.value,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: const Icon(
          Icons.account_circle,
          color: ColorSchema.borderColor,
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.raleway(
          textStyle: const TextStyle(
            color: ColorSchema.grey,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
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
        return null;
      },
      controller: _controller.password.value,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.grey,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
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
}
