import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/expense/expense_list.dart';
import 'package:inventual/src/presentation/screens/purchase/purchase_sections/add_payment_section.dart';
import 'package:inventual/src/presentation/screens/purchase/purchase_sections/view_payment_card_section.dart';
import 'package:inventual/src/utils/contstants.dart';

class HorizontalExpenseTableSection extends StatefulWidget {
  final List<Map<String, dynamic>> expenseListData;
  const HorizontalExpenseTableSection(
      {super.key, required this.expenseListData});

  @override
  State<HorizontalExpenseTableSection> createState() =>
      _HorizontalExpenseTableSectionState();
}

class _HorizontalExpenseTableSectionState
    extends State<HorizontalExpenseTableSection> {
  final ExpenseListController expenseListController = ExpenseListController();

  final List<String> list = <String>[
    'Delete',
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.expenseListData.isEmpty) {
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
    double totalGrandSum = widget.expenseListData.fold(0.0, (sum, item) {
      return sum +
          (item['amount'] is String
              ? double.tryParse(item['amount']) ?? 0.0
              : item['amount']);
    });

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
                'Voucher No',
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
                'Comment',
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
                'Grand Total',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Action',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              numeric: true,
            ),
          ],
          rows: [
            ...widget.expenseListData.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['expense_date_at'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['voucher_no'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['expense_type'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(
                        entry.value['comment'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: ColorSchema.success,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          entry.value['status'],
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: ColorSchema.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )),
                      DataCell(Text(
                        entry.value['amount'],
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorSchema.borderLightBlue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          dropdownColor: ColorSchema.white,
                          borderRadius: BorderRadius.circular(5),
                          alignment: Alignment.center,
                          hint: Text(
                            "Action",
                            style: GoogleFonts.nunito(
                                color: ColorSchema.actionColor),
                          ),
                          onChanged: (String? value) async {
                            bool isDeleted = await expenseListController
                                .deleteExpense(entry.value['id']);
                            if (isDeleted) {
                              setState(() {
                                widget.expenseListData.removeAt(entry.key);
                              });
                            }
                          },
                          items: list.map((String choice) {
                            return DropdownMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  if (choice == 'Edit')
                                    SvgPicture.asset(
                                      "assets/icons/icon_svg/edit_icon.svg",
                                      color: ColorSchema.blue,
                                      width: 16,
                                    ),
                                  if (choice == 'Payment')
                                    SvgPicture.asset(
                                      "assets/icons/icon_svg/add_payment.svg",
                                      color: ColorSchema.paymentColor,
                                      width: 18,
                                    ),
                                  if (choice == "View Payment")
                                    SvgPicture.asset(
                                      "assets/icons/icon_svg/view_payment.svg",
                                      color: ColorSchema.orange,
                                      width: 18,
                                    ),
                                  if (choice == 'Delete')
                                    SvgPicture.asset(
                                      "assets/icons/icon_svg/delete_icon.svg",
                                      color: ColorSchema.red,
                                      width: 18,
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    choice,
                                    style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                            color: ColorSchema.lightBlack)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: ColorSchema.analyticsColor3),
                        ),
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
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(Text(
                totalGrandSum.toStringAsFixed(2),
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              )),
              const DataCell(Text('')),
            ])
          ],
        ),
      ),
    );
  }

  void _buildDialogModal(BuildContext context, dynamic payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: ColorSchema.white,
        child: ViewPaymentCardSection(payment: payment),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, dynamic entry) {
    showModalBottomSheet(
      backgroundColor: ColorSchema.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      context: context,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: AddPaymentSection(payment: entry),
        );
      },
    );
  }
}
