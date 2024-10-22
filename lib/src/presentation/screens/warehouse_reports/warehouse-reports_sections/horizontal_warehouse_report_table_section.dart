import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalWarehouseReportTableSection extends StatefulWidget {
  final dynamic wareHouseList;
  const HorizontalWarehouseReportTableSection(
      {super.key, required this.wareHouseList});
  @override
  State<HorizontalWarehouseReportTableSection> createState() =>
      _HorizontalWarehouseReportTableSectionState();
}

class _HorizontalWarehouseReportTableSectionState
    extends State<HorizontalWarehouseReportTableSection> {
  late String dropdownValue;

  @override
  Widget build(BuildContext context) {
    if (widget.wareHouseList.isEmpty) {
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

    final warehousesList = widget.wareHouseList;

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
                'Name',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Address',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: [
            ...warehousesList.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(entry.value['name'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['phone'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['email'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['address'],
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
