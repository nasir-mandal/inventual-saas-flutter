import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/business_logic/units/unit_controller.dart';
import 'package:inventual_saas/src/presentation/screens/unit/unit_management_sections/update_unit_management_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/alert_dialog/no_permission_box.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/products_loaddings.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnitManagementMainScreen extends StatefulWidget {
  const UnitManagementMainScreen({super.key});

  @override
  State<UnitManagementMainScreen> createState() =>
      _UnitManagementMainScreenState();
}

class _UnitManagementMainScreenState extends State<UnitManagementMainScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  final UnitController createController = UnitController();
  late List<Map<String, dynamic>> unitUpdateData = <Map<String, dynamic>>[];
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    super.initState();
    _dependencyController.getAllUnit();
    unitUpdateData = _dependencyController.unitList;
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
    return Scaffold(
      backgroundColor: ColorSchema.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            navigateName: "Unit Management",
          )),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildInputTextField("Enter Unit Name", TextInputType.text,
                      createController.name.value, "Unit Name Is Required"),
                  const SizedBox(height: 20),
                  buildInputTextField(
                      "Enter Unit Short Name",
                      TextInputType.text,
                      createController.unitType.value,
                      "Unit Short Name Is Required"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite,
                    child: buildFromSubmitButton(
                        checkValidation: () async {
                          if (_formKey.currentState!.validate()) {
                            if (permission['add_permission_units']) {
                              bool successData =
                                  await createController.createUnit();
                              if (successData) {
                                setState(() {
                                  _dependencyController.getAllUnit();
                                });
                              }
                            } else {
                              showDialog(
                                  context: Get.context!,
                                  builder: (context) =>
                                      const NoPermissionDialog());
                            }
                          }
                        },
                        buttonName: "Create Unit"),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Text(
              "Existing Units",
              style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Obx(() => _dependencyController.getAllUnitLoading.value
                ? const Expanded(child: ProductListLoading())
                : unitUpdateData.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: ListView.separated(
                        itemCount: unitUpdateData.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                          child: Divider(
                            color: ColorSchema.borderColor,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          var unit = unitUpdateData[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(
                              unit["name"] ?? 'Unknown',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                unit["unit_type"] ?? 'N/A',
                                style:
                                    GoogleFonts.nunito(color: ColorSchema.grey),
                              ),
                            ),
                            trailing: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              color: ColorSchema.white,
                              onSelected: (value) async {
                                if (value == 'Edit') {
                                  if (permission['edit_permission_units']) {
                                    buildModalBottomSheet(context, unit);
                                  } else {
                                    showDialog(
                                        context: Get.context!,
                                        builder: (context) =>
                                            const NoPermissionDialog());
                                  }
                                } else if (value == 'Delete') {
                                  if (permission['delete_permission_units']) {
                                    bool successDelete = await createController
                                        .deleteUnits(unit["id"]);
                                    if (successDelete) {
                                      setState(() {
                                        unitUpdateData.removeAt(index);
                                      });
                                    }
                                  } else {
                                    showDialog(
                                        context: Get.context!,
                                        builder: (context) =>
                                            const NoPermissionDialog());
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
                                        color:
                                            ColorSchema.blue.withOpacity(0.7),
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
                                        color:
                                            ColorSchema.danger.withOpacity(0.7),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )))
          ],
        ),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, dynamic unit) {
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
          height: MediaQuery.of(context).size.height * 0.8,
          child: UpdateUnitManagementScreen(unit: unit),
        );
      },
    );
  }
}
