import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

// ignore: must_be_immutable
class DropdownFormFieldActionSection extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> items;
  String selectionItem;
  final String checkValue;
  final String addTitle;

  DropdownFormFieldActionSection({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.selectionItem,
    required this.checkValue,
    required this.addTitle,
  });

  @override
  State<DropdownFormFieldActionSection> createState() =>
      _DropdownFormFieldActionSectionState();
}

class _DropdownFormFieldActionSectionState
    extends State<DropdownFormFieldActionSection> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        dropdownColor: ColorSchema.white,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: ColorSchema.borderColor,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          labelText: widget.label,
          labelStyle: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: ColorSchema.lightBlack)),
          fillColor: ColorSchema.white,
          filled: true,
          hintText: widget.hint,
          hintStyle: GoogleFonts.nunito(
              textStyle: const TextStyle(
                  color: ColorSchema.grey, fontWeight: FontWeight.w500)),
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
        items: [
          ...widget.items.map((String item) {
            return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.nunito(color: ColorSchema.black),
                ));
          }),
          DropdownMenuItem(
            value: widget.checkValue,
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  color: ColorSchema.primaryColor,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  widget.addTitle,
                  style: GoogleFonts.nunito(color: ColorSchema.primaryColor),
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            if (value == "category") {
              Navigator.pushReplacementNamed(context, AppRoutes.category);
            } else if (value == "brand") {
              Navigator.pushReplacementNamed(context, AppRoutes.brand);
            } else if (value == "unit") {
              Navigator.pushReplacementNamed(context, AppRoutes.unit);
            } else if (value == "customer") {
              Navigator.pushReplacementNamed(context, AppRoutes.addCustomer);
            } else {
              widget.selectionItem = value!;
            }
          });
        });
  }
}
