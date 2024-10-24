import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/authentication.dart';
import 'package:inventual_saas/src/business_logic/settings_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/button/custom_elevated_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/dashboard_loading.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserAuthenticationController _controller =
      UserAuthenticationController();
  final SettingsController settingsController = SettingsController();
  bool _isChecked = false;
  bool _isPasswordHidden = true;

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
      height: MediaQuery.of(context).size.height,
      decoration: _buildGradientBackground(),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatar(),
              SizedBox(height: 5.h),
              _buildTitle(),
              SizedBox(height: 40.h),
              _buildUserNameTextField(),
              SizedBox(height: 15.h),
              buildPasswordTextFiled(),
              SizedBox(height: 5.h),
              buildChangeSupplierScreenAlsoRemember(),
              SizedBox(height: 5.h),
              _buildLoginButton(),
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }

  Row buildChangeSupplierScreenAlsoRemember() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _isChecked = !_isChecked;
            setState(() {});
          },
          child: Row(
            children: [
              Checkbox(
                activeColor: ColorSchema.primaryColor,
                side: const BorderSide(
                  color: ColorSchema.white,
                ),
                splashRadius: 0,
                value: _isChecked,
                onChanged: (bool? value) {
                  _isChecked = value!;
                  setState(() {});
                },
              ),
              Text(
                "Remember me",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  color: ColorSchema.white,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.clear();
            Get.offNamed(AppRoutes.findSupplier);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Text(
              "Find Supplier?",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: ColorSchema.white),
            ),
          ),
        )
      ],
    );
  }

  Widget buildPasswordTextFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextField(
        controller: _controller.password.value,
        cursorColor: ColorSchema.grey,
        style: TextStyle(fontSize: 12.sp),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordHidden = !_isPasswordHidden;
              });
            },
            icon: Icon(
              _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
              color: ColorSchema.primaryColor,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
          fillColor: ColorSchema.white,
          filled: true,
          hintText: "Password",
          hintStyle: GoogleFonts.inter(
              color: ColorSchema.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(color: ColorSchema.white, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorSchema.white, width: 1.w),
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _isPasswordHidden,
      ),
    );
  }

  Widget _buildUserNameTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextField(
        controller: _controller.username.value,
        cursorColor: ColorSchema.grey,
        style: TextStyle(fontSize: 12.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
          fillColor: ColorSchema.white,
          filled: true,
          hintText: "User Name",
          hintStyle: GoogleFonts.inter(
              color: ColorSchema.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(color: ColorSchema.white, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorSchema.white, width: 1.w),
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ColorSchema.primaryColor,
          ColorSchema.secondaryColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.5, 1.0],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorSchema.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 45.r,
        backgroundColor: ColorSchema.white,
        child: Padding(
          padding: REdgeInsets.all(12.r),
          child: SvgPicture.asset("assets/images/logo/icon_logo.svg"),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Inventual",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: ColorSchema.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorSchema.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: CustomElevatedButton(
        buttonColor: ColorSchema.primaryColor,
        buttonName: "Login",
        onPressed: _login,
        buttonRadius: 50,
      ),
    );
  }

  _login() async {
    if (_controller.username.value.text.isNotEmpty &&
        _controller.password.value.text.isNotEmpty) {
      bool loginSuccess = await _controller.login(context);
      if (loginSuccess) {
        settingsController.loadSettings();
      }
    } else {
      Fluttertoast.showToast(
          msg: "Fill up all required fields",
          backgroundColor: ColorSchema.danger,
          textColor: ColorSchema.white);
    }
  }
}
