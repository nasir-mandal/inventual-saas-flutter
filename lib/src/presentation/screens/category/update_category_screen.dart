import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual/src/data/models/category_type.dart';
import 'package:inventual/src/presentation/screens/category/category_main_screen.dart';
import 'package:inventual/src/presentation/screens/expense_category/expense_category_main_Screen.dart';
import 'package:inventual/src/presentation/widgets/dropdown/custom_drop_down.dart';
import 'package:inventual/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual/src/utils/contstants.dart';

class UpdateCategoryScreen extends StatefulWidget {
  final dynamic category;
  final dynamic backPage;
  const UpdateCategoryScreen(
      {super.key, required this.category, required this.backPage});
  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final CategoryController _controller = CategoryController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    _controller.fetchAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchema.white70,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "Edit Category",
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: ColorSchema.lightBlack,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 26,
                      color: ColorSchema.lightBlack,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Divider(color: ColorSchema.grey.withOpacity(0.3)),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(
                    () => Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                                          ColorSchema.blue.withOpacity(0.05),
                                      radius: 60,
                                      backgroundImage: _controller
                                                  .selectedFile.value !=
                                              null
                                          ? FileImage(_controller.selectedFile
                                              .value!) as ImageProvider<Object>
                                          : widget.category['images'].isNotEmpty
                                              ? NetworkImage(
                                                      widget.category['images'])
                                                  as ImageProvider<Object>
                                              : const AssetImage(
                                                      "assets/images/logo/dell.png")
                                                  as ImageProvider<Object>,
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
                          const SizedBox(height: 20),
                          Obx(() => CustomDropdownField(
                                hintText: "Select Parent Category",
                                dropdownItems: _controller.allCategoryList
                                    .map((classData) =>
                                        classData["title"] as String)
                                    .toList(),
                                onSelectedValueChanged: (value) {
                                  _controller.parentCategoryValue.value = value;
                                  _controller.parentCategoryID.value =
                                      _controller.allCategoryList.firstWhere(
                                              (item) => item["title"] == value)[
                                          "category_id"];
                                },
                              )),
                          const SizedBox(height: 20),
                          CustomDropdownField(
                            hintText:
                                "Current Type is ${widget.category['type']}",
                            dropdownItems: categoryTypeData
                                .map(
                                    (classData) => classData["title"] as String)
                                .toList(),
                            onSelectedValueChanged: (value) {
                              _controller.categoryTypeValue.value = value;
                              _controller.categoryTypeID.value =
                                  categoryTypeData.firstWhere(
                                      (item) => item["title"] == value)["id"];
                            },
                          ),
                          const SizedBox(height: 20),
                          buildOptionalInputTextField(
                            "${widget.category['title']}",
                            TextInputType.text,
                            _controller.category.value,
                          ),
                          const SizedBox(height: 20),
                          buildFromSubmitButton(
                            checkValidation: _createCategory,
                            buttonName: "Update Category",
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createCategory() async {
    if (_formKey.currentState!.validate()) {
      bool successUpdate = await _controller.updateCategory(widget.category);
      if (successUpdate) {
        if (widget.backPage == "expense") {
          Get.off(const ExpenseCategoryMainScreen());
        } else {
          Get.off(const CategoryMainScreen());
        }
      }
    }
  }
}
