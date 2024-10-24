import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/pos_sale/sales_return.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesReturnSection extends StatefulWidget {
  const SalesReturnSection({super.key});
  @override
  State<SalesReturnSection> createState() => _SalesReturnSectionState();
}

class _SalesReturnSectionState extends State<SalesReturnSection> {
  final SalesReturnController controller = SalesReturnController();
  late TextEditingController _searchController;
  String searchQuery = "";
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    controller.fetchAllReturnSales();
    _searchController = TextEditingController();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
    super.initState();
  }

  Future<Map<String, dynamic>?> loadUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("user");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permission = user['userPermissions'];
    List<Map<String, dynamic>> filteredReturnSales = controller.salesReturnList;
    if (searchQuery.isNotEmpty) {
      filteredReturnSales = filteredReturnSales.where((item) {
        return item["customer"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Sales Return"),
      ),
      body: Container(
        color: ColorSchema.white70,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Sales Return",
                  hintStyle: GoogleFonts.nunito(
                      textStyle: const TextStyle(color: ColorSchema.grey)),
                  suffixIcon: const Icon(Icons.search, color: ColorSchema.grey),
                  filled: true,
                  fillColor: ColorSchema.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: ColorSchema.grey.withOpacity(0.3), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: ColorSchema.primaryColor, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => controller.isLoading.value
                ? const UserCardLoading()
                : filteredReturnSales.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: Container(
                        color: ColorSchema.white,
                        child: ListView.builder(
                          itemCount: filteredReturnSales.length,
                          itemBuilder: (context, index) {
                            final sales = filteredReturnSales[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorSchema.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorSchema.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 12),
                                          child: Text(
                                              sales["customer"] ??
                                                  'No customer',
                                              style: GoogleFonts.raleway(
                                                color: ColorSchema.lightBlack,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.date_range_outlined,
                                                size: 16,
                                                color: ColorSchema.grey,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                sales["refund_date_at"] ?? '',
                                                style: GoogleFonts.nunito(
                                                  color: ColorSchema.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2),
                                                child: Icon(
                                                  Icons.add_home_work_outlined,
                                                  size: 16,
                                                  color: ColorSchema.grey,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2.0),
                                                child: Text(
                                                  sales["warehouse"] ?? '',
                                                  style: GoogleFonts.nunito(
                                                    color: ColorSchema.grey,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2),
                                                child: Icon(
                                                  Icons
                                                      .collections_bookmark_outlined,
                                                  size: 16,
                                                  color: ColorSchema.grey,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 2.0),
                                                child: Text(
                                                  sales["remark"] ?? '',
                                                  style: GoogleFonts.nunito(
                                                    color: ColorSchema.grey,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 12,
                                          ),
                                          child: Text(
                                            "${sales['currencySymbol']}${sales["total_amount"]}",
                                            style: GoogleFonts.nunito(
                                                color: ColorSchema.grey),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, bottom: 12),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 1),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: sales[
                                                              "refund_status"] ==
                                                          "Complete"
                                                      ? ColorSchema.success
                                                          .withOpacity(0.2)
                                                      : sales["refund_status"] ==
                                                              "Incomplete"
                                                          ? ColorSchema.warning
                                                              .withOpacity(0.2)
                                                          : ColorSchema.danger
                                                              .withOpacity(
                                                                  0.2)),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Text(
                                              sales["refund_status"] ?? '',
                                              style: GoogleFonts.nunito(
                                                  color: sales[
                                                              "refund_status"] ==
                                                          "Complete"
                                                      ? ColorSchema.success
                                                          .withOpacity(0.7)
                                                      : sales["refund_status"] ==
                                                              "Incomplete"
                                                          ? ColorSchema.warning
                                                              .withOpacity(0.7)
                                                          : ColorSchema.danger
                                                              .withOpacity(0.7),
                                                  fontSize: 12)),
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    color: ColorSchema.white,
                                    onSelected: (value) async {
                                      if (value == 'Delete') {
                                        bool isDeleted = await controller
                                            .deleteSalesReturn(sales['id']);
                                        if (isDeleted) {
                                          setState(() {
                                            controller.salesReturnList
                                                .removeAt(index);
                                          });
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem<String>(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: ColorSchema.red,
                                            ),
                                            SizedBox(width: 5),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ))),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
          buttonName: "Create Sales Return",
          routeName: permission['add_permission_sales_return']
              ? AppRoutes.createSalesReturn
              : AppRoutes.noPermission),
    );
  }
}
