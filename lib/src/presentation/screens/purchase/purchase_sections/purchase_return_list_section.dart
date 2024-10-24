import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/presentation/screens/purchase/purchase_sections/add_payment_section.dart';
import 'package:inventual_saas/src/presentation/screens/sales/salesSections/edit_sales_section.dart';
import 'package:inventual_saas/src/presentation/screens/sales/salesSections/sale_generate_invoice-section.dart';
import 'package:inventual_saas/src/presentation/screens/sales/salesSections/sale_view_payment_card_section.dart';
import 'package:inventual_saas/src/presentation/widgets/toast/delete_toast.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class HorizontalPurchaseReturnTableSection extends StatefulWidget {
  final dynamic purchasesList;
  const HorizontalPurchaseReturnTableSection(
      {super.key, required this.purchasesList});
  @override
  State<HorizontalPurchaseReturnTableSection> createState() =>
      _HorizontalPurchaseReturnTableSectionState();
}

class _HorizontalPurchaseReturnTableSectionState
    extends State<HorizontalPurchaseReturnTableSection> {
  final List<String> list = <String>[
    'Edit',
    "Invoice",
    "Payment",
    "View Payment",
    'Delete',
  ];

  @override
  Widget build(BuildContext context) {
    final salesList = widget.purchasesList;

    double totalGrandSum = 0;

    for (var data in widget.purchasesList) {
      totalGrandSum += double.parse(data['total_amount']);
    }

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
          dividerThickness: 0,
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
                'Return Status',
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
                'Discount',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: Text(
                'Shipping',
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
            ...salesList.asMap().entries.map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.nunito(textStyle: const TextStyle()),
                      )),
                      DataCell(Text(entry.value['return_purchase_date_at'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text("${entry.value['supplier']}",
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['warehouse'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: entry.value['return_status'] == 'Complete'
                                ? ColorSchema.success
                                : ColorSchema.danger,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(entry.value['return_status'],
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    color: ColorSchema.white,
                                    fontWeight: FontWeight.w600))),
                      )),
                      DataCell(Text(entry.value['total_amount'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['discount_amount'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['shipping_amount'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
                      DataCell(Text(entry.value['tax_amount'],
                          style: GoogleFonts.nunito(
                              textStyle: const TextStyle()))),
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
                              color: ColorSchema.actionColor,
                            ),
                          ),
                          onChanged: (String? value) {
                            if (value == 'Edit') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditSalesSection(sales: entry)));
                            } else if (value == "Invoice") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SaleGenerateInvoiceSection(
                                            products: entry,
                                          )));
                            } else if (value == "Payment") {
                              buildModalBottomSheet(context, entry);
                            } else if (value == "View Payment") {
                              _buildDialogModal(context, entry);
                            } else if (value == 'Delete') {
                              DeleteToast.showDeleteToast(
                                  context, entry.value["customerName"]);
                              setState(() {
                                salesList.removeAt(entry.key);
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
                                  if (choice == 'Invoice')
                                    SvgPicture.asset(
                                      "assets/icons/icon_svg/invoice_icon.svg",
                                      color: ColorSchema.indigo,
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
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: ColorSchema.analyticsColor3,
                          ),
                        ),
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
              DataCell(Text(totalGrandSum.toStringAsFixed(2),
                  style: GoogleFonts.inter(
                      textStyle:
                          const TextStyle(fontWeight: FontWeight.bold)))),
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

  void _buildDialogModal(BuildContext context, dynamic payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: ColorSchema.white,
        child: SaleViewPaymentCardSection(
          payment: payment,
        ),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, entry) {
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
