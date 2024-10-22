import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalDiscountReportTableSection extends StatefulWidget {
  final dynamic report;
  const HorizontalDiscountReportTableSection({super.key, required this.report});
  @override
  State<HorizontalDiscountReportTableSection> createState() =>
      _HorizontalStockReportTableSectionState();
}

class _HorizontalStockReportTableSectionState
    extends State<HorizontalDiscountReportTableSection> {
  @override
  Widget build(BuildContext context) {
    final reportData = widget.report;
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
                'Product Name',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Invoice',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Discount Type',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Discount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...reportData.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(entry.value['sale_date'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['warehouse_name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['product_name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['invoice_no'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['discount_type'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['discount'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
