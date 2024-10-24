import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/brand/create_brand_controller.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/screens/brand/brand_sections/update_brand_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/products_loaddings.dart';
import 'package:inventual_saas/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/from_submit_button.dart';
import 'package:inventual_saas/src/presentation/widgets/text_field/input_text.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandMainScreen extends StatefulWidget {
  const BrandMainScreen({Key? key}) : super(key: key);
  @override
  BrandMainScreenState createState() => BrandMainScreenState();
}

class BrandMainScreenState extends State<BrandMainScreen> {
  final ProductDependencyController _controller = ProductDependencyController();
  final BrandController _createController = BrandController();
  TextEditingController brandNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> user = {};
  @override
  void initState() {
    _controller.getAllBrands();
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
      backgroundColor: ColorSchema.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(navigateName: "Brand"),
      ),
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
                  GestureDetector(
                    onTap: () async {
                      await _createController.pickImage();
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
                              backgroundImage:
                                  _createController.selectedFile.value != null
                                      ? FileImage(
                                          _createController.selectedFile.value!)
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
                  const SizedBox(height: 20),
                  buildInputTextField(
                    "Enter Brand Name",
                    TextInputType.text,
                    _createController.title.value,
                    "Brand Name Is Required",
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite,
                    child: buildFromSubmitButton(
                      checkValidation: () async {
                        if (_formKey.currentState!.validate()) {
                          if (permission['add_permission_brands']) {
                            bool createSuccess =
                                await _createController.createBrand();
                            if (createSuccess) {
                              setState(() {
                                _controller.getAllBrands();
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
                      buttonName: "Create Brand",
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Text(
              "Existing Brands",
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (_controller.getAllBrandsLoading.value) {
                  return const ProductListLoading();
                } else if (_createController.deleteLoading.value) {
                  return const ProductListLoading();
                } else if (_createController.updateLoading.value) {
                  return const ProductListLoading();
                } else if (_createController.isLoading.value) {
                  return const ProductListLoading();
                } else if (_controller.brandList.isEmpty) {
                  return const NotFound();
                } else {
                  return Obx(() => _controller.getAllBrandsLoading.value
                      ? const ProductListLoading()
                      : ListView.separated(
                          itemCount: _controller.brandList.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                            child: Divider(
                              color: ColorSchema.grey.withOpacity(0.2),
                            ),
                          ),
                          itemBuilder: (context, index) {
                            var brand = _controller.brandList[index];

                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              leading: ClipOval(
                                child: brand['image'].isNotEmpty
                                    ? Image.network(
                                        brand['image'],
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
                                brand["title"],
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: PopupMenuButton(
                                padding: EdgeInsets.zero,
                                color: ColorSchema.white,
                                onSelected: (value) async {
                                  if (value == 'Edit') {
                                    if (permission['edit_permission_brands']) {
                                      buildModalBottomSheet(context, brand);
                                    } else {
                                      showDialog(
                                          context: Get.context!,
                                          builder: (context) =>
                                              const NoPermissionDialog());
                                    }
                                  } else if (value == 'Delete') {
                                    if (permission[
                                        'delete_permission_brands']) {
                                      bool deleteSuccess =
                                          await _createController
                                              .deleteBrand(brand["id"]);
                                      if (deleteSuccess) {
                                        _controller.brandList.removeAt(index);
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
                        ));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, brand) {
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
          child: UpdateBrandScreen(brand: brand),
        );
      },
    );
  }
}
