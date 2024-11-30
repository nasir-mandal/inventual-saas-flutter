import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/roles/roles_controller.dart';
import 'package:inventual_saas/src/presentation/screens/user_role/user_role_sections/user_role_update_section.dart';
import 'package:inventual_saas/src/presentation/widgets/alert_dialog/no_permission_box.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/products_loaddings.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoleMainScreen extends StatefulWidget {
  const UserRoleMainScreen({Key? key}) : super(key: key);

  @override
  State<UserRoleMainScreen> createState() => _UserRoleMainScreenState();
}

class _UserRoleMainScreenState extends State<UserRoleMainScreen> {
  final _formKey = GlobalKey<FormState>();

  final RoleController _createController = RoleController();
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    _createController.fetchAllRole();
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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "User Role"),
      ),
      body: Container(
        color: ColorSchema.white70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: buildInputTextField(
                          "Enter Role",
                          TextInputType.text,
                          _createController.name.value,
                          "Role Is Required"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: buildFromSubmitButton(
                            checkValidation: () async {
                              if (_formKey.currentState!.validate()) {
                                if (permission['add_permission_roles']) {
                                  bool successRole =
                                      await _createController.createRole();
                                  if (successRole) {
                                    setState(() {
                                      _createController.fetchAllRole();
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
                            buttonName: "Submit"),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Existing User Role",
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => _createController.roleLoading.value == true
                ? const Expanded(child: ProductListLoading())
                : _createController.roleList.isEmpty
                    ? const Expanded(child: NotFound())
                    : Expanded(
                        child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _createController.roleList.length,
                        itemBuilder: (context, index) {
                          final userRole = _createController.roleList[index];
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
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/icon_svg/profile_name.svg",
                                              width: 18,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              userRole["title"],
                                              style: GoogleFonts.raleway(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: ColorSchema.lightBlack,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    color: ColorSchema.white,
                                    onSelected: (value) async {
                                      if (value == 'Edit') {
                                        if (permission[
                                            'edit_permission_roles']) {
                                          buildModalBottomSheet(
                                              context, userRole);
                                        } else {
                                          showDialog(
                                              context: Get.context!,
                                              builder: (context) =>
                                                  const NoPermissionDialog());
                                        }
                                      } else if (value == 'Delete') {
                                        if (permission[
                                            'delete_permission_roles']) {
                                          bool successDelete =
                                              await _createController
                                                  .deleteRoles(userRole["id"]);
                                          if (successDelete) {
                                            _createController.roleList
                                                .removeAt(index);
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
                                              color: ColorSchema.blue
                                                  .withOpacity(0.7),
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
                                              color: ColorSchema.danger
                                                  .withOpacity(0.7),
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
                            ),
                          );
                        },
                      )))
          ],
        ),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, user) {
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
          height: MediaQuery.of(context).size.height * 0.3,
          child: UserRoleUpdateSection(user: user),
        );
      },
    );
  }
}
