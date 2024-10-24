import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class HorizontalPurchaseTableSection extends StatefulWidget {
  final dynamic purchasesList;
  const HorizontalPurchaseTableSection(
      {super.key, required this.purchasesList});

  @override
  State<HorizontalPurchaseTableSection> createState() =>
      _HorizontalPurchaseTableSectionState();
}

class _HorizontalPurchaseTableSectionState
    extends State<HorizontalPurchaseTableSection> {
  @override
  Widget build(BuildContext context) {
    final purchasesList = widget.purchasesList;

    double totalGrandSum = 0;

    for (var data in purchasesList) {
      String totalAmountStr = data['total_amount']?.toString() ?? '';

      // Handle potential null or empty values
      if (totalAmountStr.isNotEmpty) {
        double? totalAmount = double.tryParse(totalAmountStr);

        if (totalAmount != null) {
          totalGrandSum += totalAmount;
        } else {}
      } else {}
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
                'Supplier',
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
                'Status',
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
            DataColumn(
              label: Text(
                'Shipping Amount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Tax Amount',
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
            DataColumn(
              label: Text(
                'Total Amount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...purchasesList.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['purchase_date_at'] ?? 'N/A',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['supplier'] ?? 'N/A',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['warehouse'] ?? 'N/A',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['purchase_status'] ?? 'N/A',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['discount_amount'] ?? '0',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['shipping_amount'] ?? '0',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['tax_amount'] ?? '0',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['amount'] ?? '0',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['total_amount'] ?? '0',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
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
