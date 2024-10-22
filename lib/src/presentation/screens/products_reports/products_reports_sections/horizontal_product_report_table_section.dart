import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalProductReportTableSection extends StatefulWidget {
  final dynamic productReport;
  const HorizontalProductReportTableSection(
      {super.key, required this.productReport});
  @override
  State<HorizontalProductReportTableSection> createState() =>
      _HorizontalProductReportTableSectionState();
}

class _HorizontalProductReportTableSectionState
    extends State<HorizontalProductReportTableSection> {
  @override
  Widget build(BuildContext context) {
    final productList = widget.productReport;
    double totalGrandSum = 0;
    for (var data in productList) {
      totalGrandSum += data['purchase_amount'];
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
                'Available Stock',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Price',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Sale Quantity',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Sale Amount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Purchase Quantity',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Purchase Amount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...productList.asMap().entries.map(
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
                      DataCell(Text(entry.value['available_stock'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['price'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['sale_quantity'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['sale_amount'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['purchase_quantity'].toString(),
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['purchase_amount'].toString(),
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
