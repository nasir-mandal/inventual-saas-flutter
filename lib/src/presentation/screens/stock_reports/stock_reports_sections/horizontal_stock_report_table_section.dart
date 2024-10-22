import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalStockReportTableSection extends StatefulWidget {
  final dynamic report;
  const HorizontalStockReportTableSection({super.key, required this.report});

  @override
  State<HorizontalStockReportTableSection> createState() =>
      _HorizontalStockReportTableSectionState();
}

class _HorizontalStockReportTableSectionState
    extends State<HorizontalStockReportTableSection> {
  @override
  Widget build(BuildContext context) {
    final reportData = widget.report;

    double totalStockSum = 0;
    double totalAvailableStockSum = 0;

    for (var data in reportData) {
      totalStockSum += double.parse(data['stock'].toString());
      totalAvailableStockSum +=
          double.parse(data['available_stock'].toString());
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
                'Product Name',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Unit',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Available Stock',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Stock',
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
                      DataCell(Text(entry.value['date'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['warehouse_name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['product_name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['unit'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['available_stock'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['stock'].toString(),
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
              DataCell(Text(totalAvailableStockSum.toStringAsFixed(2),
                  style: GoogleFonts.inter(
                      textStyle:
                          const TextStyle(fontWeight: FontWeight.bold)))),
              DataCell(Text(totalStockSum.toStringAsFixed(2),
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
