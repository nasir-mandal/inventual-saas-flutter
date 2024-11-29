import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final bool isNumeric;
  final bool isEmail;
  final bool isPhone;
  final bool? isValidator;
  final String? validatorText;
  final ValueChanged<String>? onChanged;
  final bool? isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.isNumeric = false,
    this.isValidator,
    this.validatorText = "This field is required",
    this.isEmail = false,
    this.isPhone = false,
    this.onChanged,
    this.isPassword,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: ColorSchema.primaryColor.withOpacity(0.5),
        selectionColor: ColorSchema.primaryColor.withOpacity(0.2),
        selectionHandleColor: ColorSchema.primaryColor.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.labelText!,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorSchema.black.withOpacity(0.7),
                ),
              ),
            ),
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: widget.isNumeric
                ? TextInputType.number
                : widget.isEmail
                    ? TextInputType.emailAddress
                    : widget.isPhone
                        ? TextInputType.phone
                        : TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword == true
                  ? Icon(
                      Icons.remove_red_eye,
                      color: ColorSchema.grey.withOpacity(0.5),
                      size: 20,
                    )
                  : null,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              fillColor: ColorSchema.white,
              filled: true,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: ColorSchema.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorSchema.danger),
                borderRadius: BorderRadius.circular(4.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: ColorSchema.danger),
                borderRadius: BorderRadius.circular(4.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide:
                    const BorderSide(color: ColorSchema.borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: ColorSchema.primaryColor, width: 1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            validator: (widget.isValidator ?? false)
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return widget.validatorText;
                    }
                    return null;
                  }
                : null,
            onChanged: widget.onChanged,
            style: TextStyle(
              color: ColorSchema.lightBlack.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
