import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalPaymentReportTableSection extends StatefulWidget {
  final dynamic paymentList;
  const HorizontalPaymentReportTableSection(
      {super.key, required this.paymentList});

  @override
  State<HorizontalPaymentReportTableSection> createState() =>
      _HorizontalPaymentReportTableSectionState();
}

class _HorizontalPaymentReportTableSectionState
    extends State<HorizontalPaymentReportTableSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.paymentList.isEmpty) {
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

    double totalAmount = 0;

    for (var data in widget.paymentList) {
      totalAmount += double.parse(data['payable_amount']);
    }

    final paymentsList = widget.paymentList;

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
                'Sr',
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
                'Reference No',
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
                'Payment Type',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Payment Status',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Payable Amount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                'Customer Email',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              numeric: true,
            ),
          ],
          rows: [
            ...paymentsList.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['payment_date'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['warehouse_name'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['reference_no'].toString(),
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['invoice_no'].toString(),
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['payment_type'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['payment_status'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['payable_amount'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['customer_email'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                    ],
                  ),
                ),
            DataRow(cells: [
              DataCell(Text(
                'Total',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              )),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(Text(
                totalAmount.toStringAsFixed(2),
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              )),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
            ])
          ],
        ),
      ),
    );
  }
}
