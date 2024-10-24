import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual_saas/src/data/models/category_type.dart';
import 'package:inventual_saas/src/presentation/screens/category/update_category_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/products_loaddings.dart';
import 'package:inventual_saas/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseCategoryMainScreen extends StatefulWidget {
  const ExpenseCategoryMainScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseCategoryMainScreen> createState() =>
      _ExpenseCategoryMainScreenState();
}

class _ExpenseCategoryMainScreenState extends State<ExpenseCategoryMainScreen> {
  final CategoryController _controller = CategoryController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryController = TextEditingController();
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    _controller.getAllDynamicCategory("Expense");
    _controller.getAllCategory();
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
  Widget build(BuildContext context) {
    final permission = user['userPermissions'];
    return Scaffold(
      backgroundColor: ColorSchema.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Expense Category"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _controller.pickImage();
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Obx(() {
                              return CircleAvatar(
                                backgroundColor:
                                    ColorSchema.blue.withOpacity(0.1),
                                radius: 60,
                                backgroundImage: _controller
                                            .selectedFile.value !=
                                        null
                                    ? FileImage(_controller.selectedFile.value!)
                                    : const AssetImage(
                                            "assets/images/logo/dell.png")
                                        as ImageProvider,
                              );
                            }),
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: ColorSchema.primaryColor,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: ColorSchema.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => CustomDropdownField(
                          hintText: "Select Parent Category",
                          dropdownItems: _controller.allCategoryList
                              .map((classData) => classData["title"] as String)
                              .toList(),
                          onSelectedValueChanged: (value) {
                            _controller.parentCategoryValue.value = value;
                            _controller.parentCategoryID.value =
                                _controller.allCategoryList.firstWhere((item) =>
                                    item["title"] == value)["category_id"];
                          },
                        )),
                    const SizedBox(height: 8),
                    CustomDropdownField(
                      hintText: "Select Category Type",
                      dropdownItems: categoryTypeData
                          .map((classData) => classData["title"] as String)
                          .toList(),
                      onSelectedValueChanged: (value) {
                        _controller.categoryTypeValue.value = value;
                        _controller.categoryTypeID.value = categoryTypeData
                            .firstWhere((item) => item["title"] == value)["id"];
                      },
                    ),
                    const SizedBox(height: 8),
                    buildInputTextField(
                      "Enter Category",
                      TextInputType.text,
                      _controller.category.value,
                      "Category Is Required Field",
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.maxFinite,
                      child: buildFromSubmitButton(
                          checkValidation: () async {
                            if (_formKey.currentState!.validate()) {
                              if (permission['add_permission_categories']) {
                                bool createSuccess =
                                    await _controller.createCategory();
                                if (createSuccess) {
                                  setState(() {
                                    _controller
                                        .getAllDynamicCategory("Expense");
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
                          buttonName: "Create Category"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ))),
            Obx(() => _controller.isDynamicLoading.value
                ? const SizedBox()
                : Text(
                    "Expense Category",
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
            const SizedBox(height: 10),
            Obx(() => _controller.isDynamicLoading.value
                ? const Expanded(child: ProductListLoading())
                : _controller.dynamicCategoryList.isEmpty
                    ? const NotFound()
                    : Expanded(
                        child: ListView.separated(
                          itemCount: _controller.dynamicCategoryList.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                            child: Divider(
                              color: ColorSchema.grey.withOpacity(0.2),
                            ),
                          ),
                          itemBuilder: (context, index) {
                            var category =
                                _controller.dynamicCategoryList[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              leading: ClipOval(
                                child: category['images'].isNotEmpty
                                    ? Image.network(
                                        category['images'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/logo/dell.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(
                                category["title"],
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: PopupMenuButton(
                                padding: EdgeInsets.zero,
                                color: ColorSchema.white,
                                onSelected: (value) async {
                                  if (value == 'Edit') {
                                    if (permission[
                                        'edit_permission_categories']) {
                                      buildModalBottomSheet(context, category);
                                    } else {
                                      showDialog(
                                          context: Get.context!,
                                          builder: (context) =>
                                              const NoPermissionDialog());
                                    }
                                  } else if (value == 'Delete') {
                                    if (permission[
                                        'delete_permission_categories']) {
                                      bool successDelete =
                                          await _controller.deleteCategory(
                                              category["category_id"]);
                                      if (successDelete) {
                                        _controller.dynamicCategoryList
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
                              ),
                            );
                          },
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, category) {
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
          height: MediaQuery.of(context).size.height * 0.6,
          child: UpdateCategoryScreen(category: category, backPage: "expense"),
        );
      },
    );
  }
}
