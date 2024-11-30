import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventual_saas/src/business_logic/proudcts/category_controller.dart';
import 'package:inventual_saas/src/business_logic/proudcts/product_controller.dart';
import 'package:inventual_saas/src/presentation/screens/purchase/create_purchase/purchase_bills.dart';
import 'package:inventual_saas/src/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:inventual_saas/src/presentation/widgets/loadings/product_grid_loading.dart';
import 'package:inventual_saas/src/presentation/widgets/not_found.dart';
import 'package:inventual_saas/src/utils/contstants.dart';

class CreatePurchaseMainScreen extends StatefulWidget {
  const CreatePurchaseMainScreen({super.key});

  @override
  State<CreatePurchaseMainScreen> createState() =>
      _CreatePurchaseMainScreenState();
}

class _CreatePurchaseMainScreenState extends State<CreatePurchaseMainScreen> {
  final ProductController _controller = ProductController();
  final CategoryController _categoryController = CategoryController();
  final ProductDependencyController _dependencyController =
      ProductDependencyController();
  String categorySelectedValue = "All";
  String searchQuery = "";
  String selectBrand = "";
  List<Map> selectedItems = [];
  List<Map> featuredProductList = [];

  bool isCategoryDropdownOpen = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _controller.getAllProducts();
    _categoryController.getAllCategory();
    _searchController = TextEditingController();
    _dependencyController.getAllBrands();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = _controller.productList;
    if (categorySelectedValue != "All") {
      featuredProductList.clear();
      filteredProducts = filteredProducts
          .where((product) => product["categories"] == categorySelectedValue)
          .toList();
      categorySelectedValue = "All";
    }

    if (selectBrand.isNotEmpty) {
      featuredProductList.clear();
      filteredProducts = filteredProducts
          .where((product) => product["Brand"] == selectBrand)
          .toList();
      Navigator.pop(context);
      selectBrand = "";
    }

    if (searchQuery.isNotEmpty) {
      featuredProductList.clear();
      filteredProducts = filteredProducts.where((product) {
        return product["title"]
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
      searchQuery = "";
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          navigateName: "Create Purchase",
        ),
      ),
      body: Container(
        color: ColorSchema.white70,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
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
                  hintText: "Search Product",
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildElevatedButton("Category", ColorSchema.blue),
                  buildElevatedButton("Brand", ColorSchema.success),
                  buildElevatedButton("Featured", ColorSchema.orange),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => filteredProducts.isEmpty
                  ? const SizedBox()
                  : Text(
                      "Select Purchase Items",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => _controller.isLoading.value == true
                ? const ProductGridLoading()
                : filteredProducts.isEmpty
                    ? Expanded(
                        child: NotFound(
                        message: "$categorySelectedValue Not Found In Record",
                      ))
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: featuredProductList.isEmpty
                                ? filteredProducts.length
                                : featuredProductList.length,
                            itemBuilder: (context, index) {
                              final product = featuredProductList.isEmpty
                                  ? filteredProducts[index]
                                  : featuredProductList[index];
                              final isSelected =
                                  selectedItems.contains(product);

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedItems.remove(product);
                                    } else {
                                      selectedItems.add(product);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? ColorSchema.blue
                                          : ColorSchema.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: product['image'] == ''
                                            ? Image.asset(
                                                "assets/images/products/apple_device.png",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                              )
                                            : Image.network(
                                                product['image'],
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              product["title"],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Center(
                                              child: Text(
                                                "${product["currencySymbol"]}${product["price"]}",
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: ColorSchema.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: selectedItems.isNotEmpty
          ? Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PurchaseBillsSection(product: selectedItems)));
                },
                label: Text(
                  "Go Purchase Bills",
                  style: GoogleFonts.raleway(
                      color: ColorSchema.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                backgroundColor: ColorSchema.primaryColor,
              ),
            )
          : null,
    );
  }

  ElevatedButton buildElevatedButton(
    String buttonName,
    Color bgColor,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      onPressed: () {
        if (buttonName == "Brand") {
          buildBrandModal(context);
        }
        if (buttonName == "Featured") {
          final featureItem = _controller.productList
              .where((item) => item["isFeatured"] == 1)
              .toList();
          setState(() {
            featuredProductList = featureItem;
          });
        }
        if (buttonName == "Category") {
          openCategoryDropdown(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          buttonName,
          style: GoogleFonts.raleway(
              color: ColorSchema.white,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
    );
  }

  void buildBrandModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ColorSchema.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Brands",
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: ColorSchema.lightBlack,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: ColorSchema.red, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            "assets/icons/icon_svg/close_icon.svg",
                            width: 10,
                            color: ColorSchema.red,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(() => Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _dependencyController.brandList.length,
                      itemBuilder: (context, index) {
                        final brand = _dependencyController.brandList[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectBrand = brand["title"];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ColorSchema.blue.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    brand["image"],
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    brand["title"],
                                    style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void openCategoryDropdown(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(20.0, 225.0, 100.0, 0),
      elevation: 0,
      popUpAnimationStyle: AnimationStyle(
        reverseDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 500),
      ),
      color: ColorSchema.white,
      items: _categoryController.allCategoryList.map((dynamic item) {
        return PopupMenuItem<String>(
          value: item['title'],
          child: Text(item['title']),
        );
      }).toList(),
    ).then((selectedValue) {
      if (selectedValue != null) {
        setState(() {
          categorySelectedValue = selectedValue;
        });
      }
    });
  }
}
