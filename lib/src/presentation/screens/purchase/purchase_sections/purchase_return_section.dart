import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/purchase/purchase_return_controller.dart';
import 'package:inventual_saas/src/presentation/widgets/floating_aciton_button/custom_floating_action_button.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/user_card_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/routes/app_routes.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseReturnSection extends StatefulWidget {
  const PurchaseReturnSection({super.key});

  @override
  State<PurchaseReturnSection> createState() =>
      _PurchaseReturnMainScreenState();
}

class _PurchaseReturnMainScreenState extends State<PurchaseReturnSection> {
  final PurchaseReturnController controller = PurchaseReturnController();
  late TextEditingController _searchController;
  String searchQuery = "";
  late Map<String, dynamic> settings = {};
  late Map<String, dynamic> user = {};

  @override
  void initState() {
    controller.fetchAllReturnPurchases();
    _searchController = TextEditingController();
    loadSettings().then(
      (value) => setState(() {
        settings = value ?? {};
      }),
    );
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
    super.initState();
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString("settings");
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
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
  Widget build(BuildContext context) {
    if (user.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Purchase Return", style: GoogleFonts.raleway()),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final permission = user['userPermissions'] ?? {};
    List<Map<String, dynamic>> filteredReturnPurchase =
        controller.purchasesReturnList;

    if (searchQuery.isNotEmpty) {
      filteredReturnPurchase = filteredReturnPurchase.where((item) {
        return item["warehouse"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: ColorSchema.white,
        backgroundColor: ColorSchema.white,
        centerTitle: true,
        title: Text(
          "Purchase Return",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
        ),
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
                  hintText: "Search Purchase Return",
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => controller.isLoading.value
                ? const UserCardLoading()
                : filteredReturnPurchase.isEmpty
                    ? Expanded(child: NotFound())
                    : Expanded(
                        child: Container(
                          color: ColorSchema.white,
                          child: ListView.builder(
                            itemCount: filteredReturnPurchase.length,
                            itemBuilder: (context, index) {
                              final purchase = filteredReturnPurchase[index];
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
                                              purchase["supplier"] ??
                                                  'No Supplier',
                                              style: GoogleFonts.raleway(
                                                color: ColorSchema.lightBlack,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
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
                                                const SizedBox(width: 5),
                                                Text(
                                                  purchase[
                                                          "return_purchase_date_at"] ??
                                                      '',
                                                  style: GoogleFonts.nunito(
                                                    color: ColorSchema.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
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
                                                        .add_home_work_outlined,
                                                    size: 16,
                                                    color: ColorSchema.grey,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2.0),
                                                  child: Text(
                                                    purchase["warehouse"] ?? '',
                                                    style: GoogleFonts.nunito(
                                                      color: ColorSchema.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Text(
                                              "${settings['currency_symbol']}${purchase["total_amount"]}",
                                              style: GoogleFonts.nunito(
                                                  color: ColorSchema.grey),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, bottom: 12),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 1),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: purchase["return_status"] ==
                                                          "Complete"
                                                      ? ColorSchema.success
                                                          .withOpacity(0.2)
                                                      : purchase["return_status"] ==
                                                              "Incomplete"
                                                          ? ColorSchema.warning
                                                              .withOpacity(0.2)
                                                          : ColorSchema.danger
                                                              .withOpacity(
                                                                  0.2)),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              purchase["return_status"] ?? '',
                                              style: GoogleFonts.nunito(
                                                  color: purchase["return_status"] ==
                                                          "Complete"
                                                      ? ColorSchema.success
                                                          .withOpacity(0.7)
                                                      : purchase["return_status"] ==
                                                              "Incomplete"
                                                          ? ColorSchema.warning
                                                              .withOpacity(0.7)
                                                          : ColorSchema.danger
                                                              .withOpacity(0.7),
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      color: ColorSchema.white,
                                      onSelected: (value) async {
                                        bool isDeleted = await controller
                                            .deletePurchaseReturn(
                                                purchase['id']);
                                        if (isDeleted) {
                                          setState(() {
                                            controller.purchasesReturnList
                                                .removeAt(index);
                                          });
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
                        ),
                      )),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        buttonName: "Create Purchase Return",
        routeName: (permission['add_permission_purchases_return'])
            ? AppRoutes.createPurchaseReturn
            : AppRoutes.noPermission,
      ),
    );
  }
}
