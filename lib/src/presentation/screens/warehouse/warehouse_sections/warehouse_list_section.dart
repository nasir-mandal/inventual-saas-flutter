import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/warehouse/warehouse_controller.dart';
import 'package:inventual/src/presentation/screens/warehouse/warehouse_sections/update_warehouse_section.dart';
import 'package:inventual/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseListSection extends StatefulWidget {
  final dynamic warehouseList;
  const WarehouseListSection({super.key, required this.warehouseList});

  @override
  State<WarehouseListSection> createState() => _WarehouseListSectionState();
}

class _WarehouseListSectionState extends State<WarehouseListSection> {
  final CreateWarehouseController createWarehouseController =
      CreateWarehouseController();

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
      itemCount: widget.warehouseList.length,
      itemBuilder: (context, index) {
        final warehouseData = widget.warehouseList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 24),
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
                      child: Text(
                        "${warehouseData["title"]}",
                        style: GoogleFonts.raleway(
                          color: ColorSchema.lightBlack,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          const Icon(Icons.phone,
                              color: ColorSchema.grey, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            "${warehouseData["phone"]}",
                            style: GoogleFonts.nunito(
                              color: ColorSchema.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          const Icon(Icons.email,
                              color: ColorSchema.grey, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            "${warehouseData["email"]}",
                            style: GoogleFonts.nunito(
                              color: ColorSchema.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: ColorSchema.grey, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            "${warehouseData["address"]}",
                            style: GoogleFonts.nunito(
                              color: ColorSchema.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                padding: EdgeInsets.zero,
                color: ColorSchema.white,
                onSelected: (value) async {
                  if (value == 'Edit') {
                    if (permission['edit_permission_warehouses']) {
                      buildModalBottomSheet(context, warehouseData);
                    } else {
                      showDialog(
                          context: Get.context!,
                          builder: (context) => const NoPermissionDialog());
                    }
                  } else if (value == 'Delete') {
                    if (permission['delete_permission_warehouses']) {
                      bool isDeleted = await createWarehouseController
                          .deleteWarehouse(warehouseData['id']);
                      if (isDeleted) {
                        setState(() {
                          widget.warehouseList.removeAt(index);
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

  void buildModalBottomSheet(BuildContext context, warehouse) {
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
          child: UpdateWarehouseSection(warehouse: warehouse),
        );
      },
    );
  }
}
