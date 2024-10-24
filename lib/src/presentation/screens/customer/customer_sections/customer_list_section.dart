import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/people/customer/customer_controller.dart';
import 'package:inventual_saas/src/presentation/screens/customer/customer_sections/update_customer_section.dart';
import 'package:inventual_saas/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerListSection extends StatefulWidget {
  final dynamic customerList;
  const CustomerListSection({super.key, required this.customerList});

  @override
  State<CustomerListSection> createState() => _CustomerListSectionState();
}

class _CustomerListSectionState extends State<CustomerListSection> {
  final CustomerController customerController = CustomerController();

  late Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    loadUser().then(
      (value) => setState(() {
        user = value ?? {};
      }),
    );
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
    final permission = user['userPermissions'];
    return ListView.builder(
      itemCount: widget.customerList.length,
      itemBuilder: (context, index) {
        final customer = widget.customerList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 12),
                      child: Text(customer["name"],
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
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        customer['category'] ?? "No Category",
                        style: GoogleFonts.nunito(
                          color: ColorSchema.lightBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: ColorSchema.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            customer["email"],
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
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone_android_sharp,
                            size: 16,
                            color: ColorSchema.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            customer["phone"],
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
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: ColorSchema.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            customer["address"]?.toString() ??
                                'Address not available',
                            style: GoogleFonts.nunito(
                              color: ColorSchema.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 12),
                      child: Row(
                        children: [
                          Text(customer["reward"],
                              style: GoogleFonts.nunito(
                                color: ColorSchema.grey,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("Reward",
                              style: GoogleFonts.nunito(
                                color: ColorSchema.grey,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              PopupMenuButton(
                padding: EdgeInsets.zero,
                color: ColorSchema.white,
                onSelected: (value) async {
                  if (value == 'Edit') {
                    if (permission['edit_permission_customers']) {
                      buildModalBottomSheet(context, customer);
                    } else {
                      showDialog(
                          context: Get.context!,
                          builder: (context) => const NoPermissionDialog());
                    }
                  } else if (value == 'Delete') {
                    if (permission['delete_permission_customers']) {
                      bool isDeleted = await customerController
                          .deleteCustomer(customer['id']);
                      if (isDeleted) {
                        setState(() {
                          widget.customerList.removeAt(index);
                        });
                      }
                    } else {
                      showDialog(
                          context: Get.context!,
                          builder: (context) => const NoPermissionDialog());
                    }
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 20,
                          color: ColorSchema.blue.withOpacity(0.7),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20,
                          color: ColorSchema.danger.withOpacity(0.7),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text('Delete'),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void buildModalBottomSheet(BuildContext context, customer) {
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
          child: UpdateCustomerSection(customer: customer),
        );
      },
    );
  }
}
