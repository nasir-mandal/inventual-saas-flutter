import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/img_uploader/upload_dynamic_img.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/screens/products/products_sections/update_product_screen.dart';
import 'package:inventual_saas/src/presentation/widgets/no_permission_box.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListSection extends StatefulWidget {
  final dynamic isSmallScreen;
  final dynamic productList;
  const ProductListSection(
      {super.key, required this.isSmallScreen, required this.productList});
  @override
  State<ProductListSection> createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<ProductListSection> {
  final ProductController _productController = ProductController();
  final ImageUploadByIdController imageController =
      Get.put(ImageUploadByIdController());

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
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.productList.length,
        itemBuilder: (context, index) {
          final product = widget.productList[index];
          return Card(
            elevation: 0,
            color: ColorSchema.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                product['image'] == ''
                    ? GestureDetector(
                        onTap: () async {
                          await imageController
                              .pickFile(int.parse(product['id'] as String));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Obx(() {
                                final imageFile = imageController.selectedFiles[
                                    int.parse(product['id'] as String)];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageFile != null
                                      ? FadeInImage(
                                          placeholder: const AssetImage(
                                              "assets/images/gif/loading.gif"),
                                          image: FileImage(imageFile),
                                          width: 100,
                                        )
                                      : const FadeInImage(
                                          placeholder: AssetImage(
                                              "assets/images/gif/loading.gif"),
                                          image: AssetImage(
                                              "assets/images/products/apple_device.png"),
                                          width: 100,
                                        ),
                                );
                              }),
                              Obx(() {
                                final imageFile = imageController.selectedFiles[
                                    int.parse(product['id'] as String)];
                                if (imageFile == null) {
                                  return const Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: ColorSchema.primaryColor,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: ColorSchema.white,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ],
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage("assets/images/gif/loading.gif"),
                          image: NetworkImage(product['image']),
                          width: 100,
                        ),
                      ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["title"] ?? "No Category",
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                              color: ColorSchema.lightBlack,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["categories"] ?? "No Category",
                                style: GoogleFonts.raleway(
                                  textStyle: const TextStyle(
                                      color: ColorSchema.lightBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                              Text(
                                "${product["available_stock"].toString()} available",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: ColorSchema.grey, fontSize: 14)),
                              ),
                              Text(
                                "${product["currencySymbol"] ?? '\$'}${product["price"]}",
                                style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                        color: ColorSchema.grey, fontSize: 14)),
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            padding: EdgeInsets.zero,
                            color: ColorSchema.white,
                            onSelected: (value) async {
                              if (value == 'Edit') {
                                if (permission['edit_permission_products']) {
                                  buildModalBottomSheet(context, product);
                                } else {
                                  showDialog(
                                      context: Get.context!,
                                      builder: (context) =>
                                          const NoPermissionDialog());
                                }
                              } else if (value == 'Delete') {
                                if (permission['delete_permission_products']) {
                                  bool isDeleted = await _productController
                                      .deleteProduct(product["id"]);
                                  if (isDeleted) {
                                    setState(() {
                                      widget.productList.removeAt(index);
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
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void buildModalBottomSheet(BuildContext context, product) {
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
          child: UpdateProductScreen(product: product),
        );
      },
    );
  }
}
