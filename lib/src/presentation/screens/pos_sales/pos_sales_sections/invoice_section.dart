import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceSection extends StatefulWidget {
  final dynamic products;

  const InvoiceSection({Key? key, required this.products}) : super(key: key);

  @override
  State<InvoiceSection> createState() => _InvoiceSectionState();
}

class _InvoiceSectionState extends State<InvoiceSection> {
  late Map<String, dynamic> settings = {};

  @override
  void initState() {
    super.initState();
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("settings");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    int totalTaxSum = 0;
    int totalDiscountSum = 0;
    int totalAmountSum = 0;

    for (var data in widget.products) {
      totalTaxSum += int.parse(data['product-tax']);
      totalDiscountSum += int.parse(data['product-discount']);
      totalAmountSum += int.parse(data['price']);
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Invoice"),
      ),
      body: Container(
        color: ColorSchema.white70,
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildInfoSection(
                title: "Invoice Details",
                children: [
                  _buildInfoRow(
                    title: "Date",
                    value: "03/16/2024",
                  ),
                  _buildInfoRow(
                    title: "Reference",
                    value: "S-5852987452",
                  ),
                  _buildInfoRow(
                    title: "Status",
                    value: "Completed",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSectionTitle(title: "From")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildContactInfo(
                name: "Richard Joseph",
                email: "info@example.com",
                phone: "+02 782 930 782",
                address: "Milton Street, New York, USA",
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSectionTitle(title: "To"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildContactInfo(
                name: "Walk - in - Customer",
                email: "N/A",
                phone: "+02 202 396 228",
                address: "Kashba, New York, USA",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DataTable(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorSchema.borderColor,
                        width: 0.5,
                      )),
                  columnSpacing: 60,
                  headingRowHeight: 50,
                  dataRowHeight: 50,
                  dividerThickness: 0,
                  headingRowColor:
                      MaterialStateProperty.all(ColorSchema.borderLightBlue),
                  border: TableBorder.all(
                      color: ColorSchema.borderColor,
                      borderRadius: BorderRadius.circular(8)),
                  columns: [
                    DataColumn(
                      label: Text(
                        'Products',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Reference',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Unit',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Amount',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Tax',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Discount',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Sub Total',
                        style: GoogleFonts.raleway(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                  rows: [
                    ...widget.products.asMap().entries.map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text(entry.value['name'],
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                              DataCell(Text("${entry.value["barcode"]}",
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                              DataCell(Text(entry.value["unit-short"],
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                              DataCell(Text(
                                  "${settings['currency_symbol']}${entry.value["price"]}",
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                              DataCell(Text("${entry.value["product-tax"]}%",
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                              DataCell(Text(
                                  "${entry.value["product-discount"]}",
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                              DataCell(Text(
                                  "${entry.value["product-discount"]}",
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle()))),
                            ],
                          ),
                        ),
                    DataRow(cells: [
                      DataCell(Text('Total=',
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      DataCell(Text(totalAmountSum.toStringAsFixed(2),
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      DataCell(Text(totalTaxSum.toStringAsFixed(2),
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      DataCell(Text(totalDiscountSum.toStringAsFixed(2),
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      DataCell(Text(totalDiscountSum.toStringAsFixed(2),
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                    ]),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Order Discount =',
                            style: GoogleFonts.raleway(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const DataCell(Text('')),
                        const DataCell(Text('')),
                        const DataCell(Text('')),
                        const DataCell(Text('')),
                        const DataCell(Text('')),
                        const DataCell(Text('-0.00')),
                      ],
                    ),
                    DataRow(cells: [
                      DataCell(Text('Order Tax =',
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('+3 (2%)')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Grand Total =',
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      DataCell(Text(totalDiscountSum.toStringAsFixed(2))),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Paid Amount =',
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('96.0')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Due Amount =',
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)))),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('')),
                      const DataCell(Text('0.00')),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "Sale Notes : ",
                    style: GoogleFonts.raleway(
                        color: ColorSchema.lightBlack,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: "N/A",
                    style: GoogleFonts.nunito(
                      color: ColorSchema.grey,
                    ))
              ])),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "Remarks : ",
                    style: GoogleFonts.raleway(
                        color: ColorSchema.lightBlack,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: "N/A",
                    style: GoogleFonts.nunito(
                      color: ColorSchema.grey,
                    ))
              ])),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "Created By : ",
                    style: GoogleFonts.raleway(
                        color: ColorSchema.lightBlack,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: "Richard Joseph",
                    style: GoogleFonts.nunito(
                      color: ColorSchema.grey,
                    ))
              ])),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "Email : ",
                    style: GoogleFonts.raleway(
                        color: ColorSchema.lightBlack,
                        fontWeight: FontWeight.w500)),
                TextSpan(
                    text: "info@example.com",
                    style: GoogleFonts.nunito(
                      color: ColorSchema.grey,
                    ))
              ])),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildOutlineButton(context, "PDF", ColorSchema.primaryColor,
                      Icons.picture_as_pdf_outlined),
                  const SizedBox(
                    width: 15,
                  ),
                  buildOutlineButton(context, "Email",
                      ColorSchema.analyticsColor1, Icons.email_outlined)
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [ColorSchema.profileColor1, ColorSchema.analyticsColor2],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
              color: ColorSchema.white70,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              color: ColorSchema.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: ColorSchema.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title}) {
    return Text(
      title,
      style: GoogleFonts.raleway(
        color: ColorSchema.lightBlack,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );
  }

  Widget _buildContactInfo({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactItem(title: "Name", value: name),
        _buildContactItem(title: "Email", value: email),
        _buildContactItem(title: "Phone", value: phone),
        _buildContactItem(title: "Address", value: address),
      ],
    );
  }

  Widget _buildContactItem({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: GoogleFonts.raleway(
              color: ColorSchema.lightBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(color: ColorSchema.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    double calculateTotalPrice(double price, double tax, double discount) {
      double total = (price * (1 + tax / 100)) - (price * discount / 100);
      return double.parse(total.toStringAsFixed(2));
    }

    double grandTotal = 0.0;
    for (var data in widget.products) {
      grandTotal += calculateTotalPrice(
          double.parse(data['price']),
          double.parse(data['product-tax']),
          double.parse(data['product-discount']));
    }

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Invoice',
              style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            data: <List<dynamic>>[
              <dynamic>['Product', 'Tax', 'Discount', 'Price', "Sub Total"],
              for (var data in widget.products)
                [
                  data['name'],
                  double.parse(data['product-tax']),
                  double.parse(data['product-discount']),
                  double.parse(data['price']),
                  calculateTotalPrice(
                      double.parse(data['price']),
                      double.parse(data['product-tax']),
                      double.parse(data['product-discount'])),
                ],
              ['', '', '', 'Grand Total', grandTotal],
            ],
          ),
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/invoice.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
  }

  buildOutlineButton(
      BuildContext context, String buttonName, Color color, icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(color: color, width: 1),
          elevation: 0,
          backgroundColor: ColorSchema.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      onPressed: () {
        if (buttonName == "PDF") {
          generatePdf();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              buttonName,
              style: GoogleFonts.raleway(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
