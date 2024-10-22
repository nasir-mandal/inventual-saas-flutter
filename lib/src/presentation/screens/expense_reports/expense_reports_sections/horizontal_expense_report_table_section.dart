import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalExpenseReportTableSection extends StatefulWidget {
  final dynamic report;
  const HorizontalExpenseReportTableSection({super.key, required this.report});
  @override
  State<HorizontalExpenseReportTableSection> createState() =>
      _HorizontalExpenseReportTableSectionState();
}

class _HorizontalExpenseReportTableSectionState
    extends State<HorizontalExpenseReportTableSection> {
  @override
  Widget build(BuildContext context) {
    final reportList = widget.report;
    double totalGrandSum = 0;
    for (var data in reportList) {
      totalGrandSum += double.parse(data['amount']);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DataTable(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorSchema.borderColor, width: 0.5),
          ),
          columnSpacing: 60,
          headingRowHeight: 50,
          dataRowHeight: 50,
          headingRowColor:
              MaterialStateProperty.all(ColorSchema.grey.withOpacity(0.1)),
          dividerThickness: 0,
          border: TableBorder.all(
            color: ColorSchema.borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
          columns: [
            DataColumn(
              label: Text(
                'SL',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Warehouse',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Category',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Expense Type',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...reportList.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(entry.value['expense_date'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['warehouse_name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['category_name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['expense_type'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['amount'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                    ],
                  ),
                ),
            DataRow(cells: [
              DataCell(Text('Total',
                  style: GoogleFonts.raleway(
                      textStyle:
                          const TextStyle(fontWeight: FontWeight.bold)))),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(Text(totalGrandSum.toStringAsFixed(2),
                  style: GoogleFonts.inter(
                      textStyle:
                          const TextStyle(fontWeight: FontWeight.bold)))),
            ])
          ],
        ),
      ),
    );
  }
}
