import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class CustomDropdownField extends StatefulWidget {
  final List<String> dropdownItems;
  final String hintText;
  final dynamic onSelectedValueChanged;
  final String? Function(String?)? validator;
  final double? closedHeaderPaddingVertical;
  final double? closedHeaderPaddingHorizontal;
  final double? expandedHeaderPaddingVertical;
  final double? expandedHeaderPaddingHorizontal;
  final double closedBorderRadius;
  final double expandedBorderRadius;
  final double? hintFontSize;
  final Color? hintTextColor;
  final Color? backgroundColor;
  final Color? expandedBgColor;
  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.dropdownItems,
    required this.onSelectedValueChanged,
    this.validator,
    this.closedHeaderPaddingVertical,
    this.closedHeaderPaddingHorizontal,
    this.expandedHeaderPaddingHorizontal,
    this.expandedHeaderPaddingVertical,
    this.closedBorderRadius = 8,
    this.expandedBorderRadius = 8,
    this.hintFontSize,
    this.hintTextColor,
    this.backgroundColor,
    this.expandedBgColor,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      closedHeaderPadding: EdgeInsets.symmetric(
          vertical: widget.closedHeaderPaddingVertical ?? 14,
          horizontal: widget.closedHeaderPaddingHorizontal ?? 16),
      expandedHeaderPadding: EdgeInsets.symmetric(
          vertical: widget.expandedHeaderPaddingVertical ?? 12,
          horizontal: widget.expandedHeaderPaddingHorizontal ?? 16),
      validateOnChange: true,
      validator: widget.validator,
      decoration: CustomDropdownDecoration(
          closedSuffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: ColorSchema.grey,
          ),
          expandedSuffixIcon: Icon(
            Icons.keyboard_arrow_up,
            color: ColorSchema.grey,
          ),
          headerStyle: const TextStyle(fontSize: 16),
          listItemStyle: const TextStyle(fontSize: 16),
          closedFillColor: widget.backgroundColor ?? ColorSchema.light,
          hintStyle: GoogleFonts.inter(
              color: widget.hintTextColor ?? ColorSchema.grey,
              fontSize: widget.hintFontSize ?? 14,fontWeight: FontWeight.w600),
          closedBorderRadius: BorderRadius.circular(widget.closedBorderRadius),
          expandedBorderRadius:
              BorderRadius.circular(widget.expandedBorderRadius),
          closedBorder: Border.all(color: ColorSchema.borderColor, width: 1),
          expandedBorder: Border.all(color: ColorSchema.light),
          expandedFillColor: widget.expandedBgColor ?? ColorSchema.white),
      hintText: widget.hintText,
      items: widget.dropdownItems,
      onChanged: widget.onSelectedValueChanged,
    );
  }
}
