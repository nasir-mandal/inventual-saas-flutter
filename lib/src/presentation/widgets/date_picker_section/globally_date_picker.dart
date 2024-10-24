import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class GloballyDatePicker extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;

  const GloballyDatePicker({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
  });

  @override
  State<GloballyDatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<GloballyDatePicker> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTap: () {
        _selectDate(context, _selectedDay, widget.controller);
      },
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            _selectDate(context, _selectedDay, widget.controller);
          },
          icon: SvgPicture.asset(
            "assets/icons/icon_svg/calendar.svg",
            width: 20,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        labelText: widget.labelText,
        labelStyle: GoogleFonts.raleway(
          color: ColorSchema.lightBlack,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        fillColor: ColorSchema.white,
        filled: true,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: ColorSchema.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorSchema.primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime selectedDate,
      TextEditingController controller) async {
    final DateTime? picked = await showRoundedDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.utc(2020, 1, 1),
      lastDate: DateTime.utc(2030, 12, 31),
      borderRadius: 12,
      height: MediaQuery.of(context).size.height * 0.35,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: ColorSchema.primaryColor),
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleYearButton: const TextStyle(
          color: ColorSchema.white70,
          fontSize: 20,
        ),
        textStyleDayButton: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        paddingDatePicker: const EdgeInsets.all(10),
        textStyleButtonPositive: const TextStyle(
            color: ColorSchema.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold),
        textStyleButtonNegative: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundHeader: ColorSchema.primaryColor,
        textStyleButtonAction: const TextStyle(
          color: ColorSchema.white,
          fontSize: 18,
        ),
        textStyleCurrentDayOnCalendar: const TextStyle(
          color: ColorSchema.primaryColor,
          fontSize: 16,
        ),
        textStyleDayOnCalendarSelected: GoogleFonts.nunito(
          textStyle: const TextStyle(
            color: ColorSchema.white,
            fontSize: 16,
          ),
        ),
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        _selectedDay = picked;
        controller.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }
}
