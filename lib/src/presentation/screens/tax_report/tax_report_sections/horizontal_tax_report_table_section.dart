import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalTaxReportTableSection extends StatefulWidget {
  final dynamic listData;
  const HorizontalTaxReportTableSection({super.key, required this.listData});
  @override
  State<HorizontalTaxReportTableSection> createState() =>
      _HorizontalTaxReportTableSectionState();
}

class _HorizontalTaxReportTableSectionState
    extends State<HorizontalTaxReportTableSection> {
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    if (widget.listData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorSchema.lightBlack),
        ),
      );
    }

    final taxList = widget.listData;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DataTable(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorSchema.borderColor, width: 0.5)),
          columnSpacing: 60,
          headingRowHeight: 50,
          dataRowHeight: 50,
          headingRowColor:
              MaterialStateProperty.all(ColorSchema.grey.withOpacity(0.1)),
          dividerThickness: 0.0,
          border: TableBorder.all(
              color: ColorSchema.borderColor,
              borderRadius: BorderRadius.circular(8)),
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
                'Warehouse Name',
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
                'Invoice No',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Tax Type',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Tax',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...taxList.asMap().entries.map(
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
                      DataCell(Text(entry.value['tax_type'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['tax'],
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
