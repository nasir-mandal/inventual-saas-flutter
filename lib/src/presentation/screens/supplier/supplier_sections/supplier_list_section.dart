import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/people/supplier/create_supplier_controller.dart';
import 'package:inventual/src/presentation/screens/supplier/supplier_sections/updateSupplierSection.dart';
import 'package:inventual/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierListSection extends StatefulWidget {
  final dynamic suppliersList;
  const SupplierListSection({super.key, required this.suppliersList});

  @override
  State<SupplierListSection> createState() => _SupplierListSectionState();
}

class _SupplierListSectionState extends State<SupplierListSection> {
  final CreateSupplierController createSupplierController =
      CreateSupplierController();

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
      itemCount: widget.suppliersList.length,
      itemBuilder: (context, index) {
        final supplier = widget.suppliersList[index];
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
                      padding: const EdgeInsets.only(left: 10, top: 12),
                      child: Text(supplier["title"],
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
                        supplier["company_name"],
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
                            supplier["email"],
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
                            supplier["phone"],
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
                            Icons.location_on_outlined,
                            size: 16,
                            color: ColorSchema.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            supplier["address"],
                            style: GoogleFonts.nunito(
                              color: ColorSchema.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 12),
                      child: Row(
                        children: [
                          Text(supplier["supplier_code"],
                              style: GoogleFonts.nunito(
                                color: ColorSchema.grey,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("Code",
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
                    if (permission['edit_permission_suppliers']) {
                      buildModalBottomSheet(context, supplier);
                    } else {
                      showDialog(
                          context: Get.context!,
                          builder: (context) => const NoPermissionDialog());
                    }
                  } else if (value == 'Delete') {
                    if (permission['delete_permission_suppliers']) {
                      bool isDeleted = await createSupplierController
                          .deleteSupplierList(supplier['id']);
                      if (isDeleted) {
                        setState(() {
                          widget.suppliersList.removeAt(index);
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
                          color: ColorSchema.blue.withOpacity(0.7),
                          size: 20,
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
                          color: ColorSchema.danger.withOpacity(0.7),
                          size: 20,
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

  void buildModalBottomSheet(BuildContext context, supplier) {
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
          child: UpdateSupplierSection(supplier: supplier),
        );
      },
    );
  }
}
