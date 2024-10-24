import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:inventual/src/network/services/network_api_services.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDependencyController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool getAllBrandsLoading = true.obs;
  final RxBool getAllVariantsLoading = true.obs;
  final RxBool getAllTypesLoading = true.obs;
  final RxBool getAllSuppliersLoading = true.obs;
  final RxBool getAllWareHouseLoading = true.obs;
  final RxBool getAllUnitLoading = true.obs;
  final RxBool getAllBarcodeLoading = true.obs;
  final RxBool getAllCustomerLoading = true.obs;
  final RxBool getAllBillersLoading = true.obs;
  final RxBool getAllCompanyLoading = true.obs;
  final RxBool productCodeLoading = true.obs;
  final RxBool colorLoading = true.obs;
  final RxBool sizeLoading = true.obs;
  final RxBool taxLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxString parentCategoryValue = ''.obs;
  final RxInt parentCategoryID = 0.obs;
  final Rx<TextEditingController> category = TextEditingController().obs;
  final RxList<Map<String, dynamic>> brandList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> variantsList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> typesList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> suppliersList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> wareHouseList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> unitList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> barCodeList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> customerList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> billersList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allCategoryList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> companyList = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> productCode = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> taxPercentList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> colorVariantList =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> sizeVariantList =
      <Map<String, dynamic>>[].obs;

  void getAllBrands() async {
    getAllBrandsLoading.value = true;
    await fetchAllBrands();
    getAllBrandsLoading.value = false;
  }

  void getAllVariants() async {
    getAllVariantsLoading.value = true;
    await fetchAllVariants();
    getAllVariantsLoading.value = false;
  }

  void getAllTypes() async {
    getAllTypesLoading.value = true;
    await fetchAllTypes();
    getAllTypesLoading.value = false;
  }

  void getAllSuppliers() async {
    getAllSuppliersLoading.value = true;
    await fetchAllSuppliers();
    getAllSuppliersLoading.value = false;
  }

  void getAllWareHouse() async {
    getAllWareHouseLoading.value = true;
    await fetchAllWareHouse();
    getAllWareHouseLoading.value = false;
  }

  void getAllUnit() async {
    getAllUnitLoading.value = true;
    await fetchAlUnit();
    getAllUnitLoading.value = false;
  }

  void getAllBarcode() async {
    getAllBarcodeLoading.value = true;
    await fetchAllBarcode();
    getAllBarcodeLoading.value = false;
  }

  void getAllCustomers() async {
    getAllCustomerLoading.value = true;
    await fetchAllCustomers();
    getAllCustomerLoading.value = false;
  }

  void getAllBillers() async {
    getAllBillersLoading.value = true;
    await fetchAllBillers();
    getAllBillersLoading.value = false;
  }

  void getAllCompany() async {
    getAllCompanyLoading.value = true;
    await fetchAllCompany();
    getAllCompanyLoading.value = false;
  }

  void getProductCode() async {
    productCodeLoading.value = true;
    await fetchProductCode();
    productCodeLoading.value = false;
  }

  void getAllTaxPercents() async {
    taxLoading.value = true;
    await fetchAllTaxPercents();
    taxLoading.value = false;
  }

  void getAllColors() async {
    colorLoading.value = true;
    await fetchAllColors();
    colorLoading.value = false;
  }

  void getAllSize() async {
    sizeLoading.value = true;
    await fetchAllSize();
    sizeLoading.value = false;
  }

  Future<void> fetchAllColors() async {
    try {
      colorLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}variants/list?type=Color";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
        colorVariantList.clear();
        colorVariantList.addAll(data);
        colorLoading.value = false;
      } else {
        colorLoading.value = false;
      }
    } catch (e) {
      colorLoading.value = false;
    } finally {
      colorLoading.value = false;
    }
  }

  Future<void> fetchAllSize() async {
    try {
      sizeLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}variants/list?type=Size";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
        sizeVariantList.clear();
        sizeVariantList.addAll(data);
        sizeLoading.value = false;
      } else {
        sizeLoading.value = false;
      }
    } catch (e) {
      sizeLoading.value = false;
    } finally {
      sizeLoading.value = false;
    }
  }

  Future<void> fetchAllTaxPercents() async {
    try {
      taxLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}taxes/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
        taxPercentList.clear();
        taxPercentList.addAll(data);
        taxLoading.value = false;
      } else {
        taxLoading.value = false;
      }
    } catch (e) {
      taxLoading.value = false;
    } finally {
      taxLoading.value = false;
    }
  }

  Future<void> fetchProductCode() async {
    try {
      productCodeLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}products/code";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = Map<String, dynamic>.from(jsonResponse["data"]);
        productCode.clear();
        productCode.addAll(data);
        productCodeLoading.value = false;
      } else {
        productCodeLoading.value = false;
      }
    } catch (e) {
      productCodeLoading.value = false;
    } finally {
      productCodeLoading.value = false;
    }
  }

  Future<void> fetchAllTypes() async {
    try {
      getAllTypesLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}types/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);
        typesList.clear();
        typesList.addAll(data);
        getAllTypesLoading.value = false;
      } else {
        getAllTypesLoading.value = false;
      }
    } catch (e) {
      getAllTypesLoading.value = false;
    } finally {
      getAllTypesLoading.value = false;
    }
  }

  Future<void> fetchAllBrands() async {
    try {
      getAllBrandsLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}brands/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        brandList.clear();
        final List<Map<String, dynamic>> resolvedBrands =
            await Future.wait(data.map((item) async {
          final images = item["images"] as List<dynamic>;
          String imageUrl = images.isNotEmpty
              ? await AppStrings.getImageUrl(images[0]["path"])
              : '';
          return {
            "title": item["title"] ?? '',
            "id": item["id"] as int? ?? 0,
            "image": imageUrl,
          };
        }).toList());
        brandList.addAll(resolvedBrands);
        getAllBrandsLoading.value = false;
      } else {
        getAllBrandsLoading.value = false;
      }
    } catch (e) {
      getAllBrandsLoading.value = false;
    } finally {
      getAllBrandsLoading.value = false;
    }
  }

  Future<void> fetchAllVariants() async {
    try {
      getAllVariantsLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}variants/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        variantsList.clear();
        variantsList.addAll(data
            .map((item) => {
                  "variant_type": item["variant_type"] ?? '',
                  "id": item["id"] as int? ?? 0,
                })
            .toList());
        getAllVariantsLoading.value = false;
      } else {
        getAllVariantsLoading.value = false;
      }
    } catch (e) {
      getAllVariantsLoading.value = false;
    } finally {
      getAllVariantsLoading.value = false;
    }
  }

  Future<void> fetchAllSuppliers() async {
    try {
      getAllSuppliersLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}suppliers/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        suppliersList.clear();
        suppliersList.addAll(data.map((item) {
          final company = item["company"] as Map<String, dynamic>?;
          final country = item["country"] as Map<String, dynamic>?;
          final fName = item["first_name"] as String;
          final lastName = item["last_name"] as String? ?? '';

          final createdAtString = item["created_at"] ?? '';
          final createdAt = createdAtString.isNotEmpty
              ? DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ')
                  .parse(createdAtString, true)
              : null;
          final formattedCreatedAt = createdAt != null
              ? DateFormat('yyyy-MM-dd').format(createdAt.toLocal())
              : '';

          String purchaseDateAt = formattedCreatedAt;
          String formattedDate = '';

          if (purchaseDateAt.isNotEmpty) {
            try {
              final DateTime parsedDate = DateTime.parse(purchaseDateAt);
              formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = purchaseDateAt;
            }
          }

          return {
            "first_name": fName,
            "last_name": lastName,
            "id": item["id"] as int? ?? 0,
            "title": "$fName $lastName",
            "phone": item["phone"] ?? '',
            "email": item["email"] ?? '',
            "city": item["city"] ?? '',
            "zip_code": item["zip_code"] ?? '',
            "company_id": item["company_id"] ?? '',
            "country_id": item["country_id"] ?? '',
            "address": item["address"] ?? '',
            "supplier_code": item["supplier_code"] ?? '00',
            "company_name":
                company?["company_name"] as String? ?? 'Company Not Found',
            "country_name":
                country?["country_name"] as String? ?? 'country Not Found',
            "date": formattedDate
          };
        }).toList());
        suppliersList.refresh();
        getAllSuppliersLoading.value = false;
      } else {
        getAllSuppliersLoading.value = false;
      }
    } catch (e) {
      getAllSuppliersLoading.value = false;
    } finally {
      getAllSuppliersLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllWareHouse() async {
    try {
      getAllWareHouseLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}warehouses/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        wareHouseList.clear();
        wareHouseList.addAll(data.map((item) {
          String createdAt = item["created_at"] ?? '';
          String formattedDate = '';
          if (createdAt.isNotEmpty) {
            try {
              final DateTime parsedDate = DateTime.parse(createdAt);
              formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
            } catch (e) {
              formattedDate = createdAt;
            }
          }

          return {
            "title": item["name"] ?? '',
            "phone": item["phone"] ?? '',
            "email": item["email"] ?? '',
            "address": item["address"] ?? '',
            "city": item["city"] ?? '',
            "zip_code": item["zip_code"] ?? '',
            "description": item["description"] ?? '',
            "country_id": item["country_id"] ?? '',
            "country_name": item["country"]['country_name'] ?? '',
            "id": item["id"] as int? ?? 0,
            "created_at": createdAt,
            "date": formattedDate,
          };
        }).toList());
        wareHouseList.refresh();
        getAllWareHouseLoading.value = false;
        return wareHouseList;
      } else {
        getAllWareHouseLoading.value = false;
        return [];
      }
    } catch (e) {
      getAllWareHouseLoading.value = false;
      return [];
    } finally {
      getAllWareHouseLoading.value = false;
    }
  }

  Future<void> fetchAllCompany() async {
    try {
      getAllCompanyLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}company/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        companyList.clear();
        companyList.addAll(data
            .map((item) => {
                  "title": item["title"] ?? '',
                  "id": item["id"] as int? ?? 0,
                })
            .toList());
        companyList.refresh();
        getAllCompanyLoading.value = false;
      } else {
        getAllCompanyLoading.value = false;
      }
    } catch (e) {
      getAllCompanyLoading.value = false;
    } finally {
      getAllCompanyLoading.value = false;
    }
  }

  Future<void> fetchAlUnit() async {
    try {
      getAllUnitLoading.value = true;

      final url = "${await AppStrings.getBaseUrlV1()}units/list";
      final jsonResponse = await _apiServices.getApiV2(url);

      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = List<Map<String, dynamic>>.from(jsonResponse["data"]);

        unitList.clear();
        for (var item in data) {
          unitList.add({
            "id": item["id"] ?? 0,
            "name": item["name"] ?? 'Unknown',
            "unit_type": item["unit_type"] ?? 'Unknown',
            "status": item["status"] ?? 'Inactive',
            "created_at": item["created_at"] ?? 'Unknown',
            "updated_at": item["updated_at"] ?? 'Unknown',
          });
        }
      }
    } finally {
      getAllUnitLoading.value = false;
    }
  }

  Future<void> fetchAllBarcode() async {
    try {
      getAllBarcodeLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}barcodes/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        barCodeList.clear();
        barCodeList.addAll(data
            .map((item) => {
                  "title": item["barcode"] ?? '',
                  "id": item["id"] as int? ?? 0,
                })
            .toList());
        barCodeList.refresh();
        getAllBarcodeLoading.value = false;
      } else {
        getAllBarcodeLoading.value = false;
      }
    } catch (e) {
      getAllBarcodeLoading.value = false;
    } finally {
      getAllBarcodeLoading.value = false;
    }
  }

  Future<void> fetchAllCustomers() async {
    try {
      getAllCustomerLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}customers/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        customerList.clear();
        customerList.addAll(data
            .map((item) => {
                  "id": item["id"] as int? ?? 0,
                  "title": "${item["first_name"]} ${item["last_name"]}",
                  "phone": item["phone"] ?? '',
                  "email": item["email"] ?? '',
                  "city": item["city"] ?? '',
                  "zip_code": item["zip_code"] ?? '',
                  "address": item["address"] ?? '',
                  "customer_category": item["category"] != null
                      ? item["category"]["title"] ?? ''
                      : '',
                })
            .toList());
        customerList.refresh();
        getAllCustomerLoading.value = false;
      } else {
        getAllCustomerLoading.value = false;
      }
    } catch (e) {
      getAllCustomerLoading.value = false;
    } finally {
      getAllCustomerLoading.value = false;
    }
  }

  Future<void> fetchAllBillers() async {
    try {
      getAllBillersLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}billers/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse != null && jsonResponse["data"] != null) {
        final data = jsonResponse["data"] as List;
        billersList.clear();
        billersList.addAll(data
            .map((item) => {
                  "id": item["id"] as int? ?? 0,
                  "warehouse_id": item["warehouse_id"] as int? ?? 0,
                  "country_id": item["country_id"] as int? ?? 0,
                  "title": "${item["first_name"]} ${item["last_name"]}",
                  "phone": item["phone"] ?? '',
                  "first_name": item["first_name"] ?? '',
                  "last_name": item["last_name"] ?? '',
                  "email": item["email"] ?? '',
                  "city": item["city"] ?? '',
                  "zip_code": item["zip_code"] ?? '',
                  "address": item["address"] ?? '',
                  "biller_code": item["biller_code"] ?? '',
                  "warehouse": item["warehouse"]["name"] ?? '',
                  "country": item["country"]["country_name"] ?? '',
                  "nid_passport_number": item["nid_passport_number"] ?? '',
                  "date_of_join": item["date_of_join"] ?? '',
                })
            .toList());
        billersList.refresh();
        getAllBillersLoading.value = false;
      } else {
        getAllBillersLoading.value = false;
      }
    } catch (e) {
      getAllBillersLoading.value = false;
    } finally {
      getAllBillersLoading.value = false;
    }
  }
}

class ProductController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = true.obs;
  final RxBool deleteLoading = true.obs;
  final RxBool notFound = true.obs;
  final RxString deletedProductID = ''.obs;
  final RxList<Map<String, dynamic>> productList = <Map<String, dynamic>>[].obs;

  void getAllProducts() async {
    isLoading.value = true;
    await fetchAllProducts();
    isLoading.value = false;
  }

  Future<bool> deleteProduct(String id) async {
    try {
      deleteLoading.value = true;

      final String url =
          "${await AppStrings.getBaseUrlV1()}products/delete/$id";
      final jsonResponse = await _apiServices.deleteApiV2(url);

      if (jsonResponse != null && jsonResponse["success"] == true) {
        deletedProductID.value = id;
        Get.snackbar(
          "Success",
          "Product deleted successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete the product",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
      return false;
    } finally {
      deleteLoading.value = false;
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString('settings') ?? '';
      String currencySymbol = '';
      if (settingsString.isNotEmpty) {
        final settings = jsonDecode(settingsString);
        currencySymbol = settings['currency_symbol'] ?? '\$';
      }
      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}products/list";
      final jsonResponse = await _apiServices.getApiV2(url);
      if (jsonResponse?["data"] != null) {
        productList.clear();
        final List<Map<String, dynamic>> resolvedProducts = await Future.wait(
          (jsonResponse["data"] as List).map((item) async {
            final categories = item["categories"] as List?;
            final colors = item["color_variant"] as List?;
            final sizes = item["size_variant"] as List?;
            final images = item["images"] as List?;

            final categoryTitle = categories?.isNotEmpty == true
                ? categories![0]["title"] ?? 'No Category'
                : 'No Category';
            final categoryID = categories?.isNotEmpty == true
                ? categories![0]["id"].toString()
                : '';
            final colorTitle = colors?.isNotEmpty == true
                ? colors![0]["name"] ?? 'No color'
                : 'No color';
            final colorID =
                colors?.isNotEmpty == true ? colors![0]["id"].toString() : '';
            final sizeID =
                sizes?.isNotEmpty == true ? sizes![0]["id"].toString() : '';
            final sizeTitle =
                sizes?.isNotEmpty == true ? sizes![0]["name"].toString() : '';
            final image = images?.isNotEmpty == true
                ? await AppStrings.getImageUrl(images![0]["path"])
                : '';
            final brand = item["brand"]?['title'] ?? 'No Brand Found';
            final supplierFirstName = item["supplier"]?['first_name'] ?? '';
            final supplierLastName = item["supplier"]?['last_name'] ?? '';
            final supplier = "$supplierFirstName $supplierLastName";
            final typeName = item["type"]?['type'] ?? 'No type Found';
            final taxId = item["tax_id"]?.toString() ?? '';
            final unit = item["unit"]?['name'] ?? 'No unit Found';
            final unitID = item["unit"]?["id"].toString() ?? '';
            final isFeatured = item["is_featured"] ?? 0;
            final createdAtString = item["created_at"] ?? '';
            final formattedCreatedAt = createdAtString.isNotEmpty
                ? DateFormat('yyyy-MM-dd').format(
                    DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ')
                        .parse(createdAtString, true)
                        .toLocal())
                : '';
            String purchaseDateAt = formattedCreatedAt;
            String formattedDate = '';
            if (purchaseDateAt.isNotEmpty) {
              try {
                final DateTime parsedDate = DateTime.parse(purchaseDateAt);
                formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
              } catch (e) {
                formattedDate = purchaseDateAt;
              }
            }
            return {
              "title": item["title"] ?? '',
              "is_featured": item["is_featured"] ?? '',
              "is_promo_sale": item["is_promo_sale"] ?? '',
              "promo_price": item["promo_price"] ?? '',
              "promo_start_at": item["promo_start_at"] ?? '',
              "promo_end_at": item["promo_end_at"] ?? '',
              "price": item["price"]?.toString() ?? '',
              "tax": item["tax"]?.toString() ?? '',
              "tax_type": item["tax_type"] ?? '',
              "tax_method": item["tax_method"] ?? '',
              "discount": item["discount"]?.toString() ?? '',
              "discount_type": item["discount_type"] ?? '',
              "product_code": item["product_code"] ?? '',
              "id": item["id"]?.toString() ?? '',
              "supplier_id": item["supplier_id"]?.toString() ?? '',
              "brand_id": item["brand_id"]?.toString() ?? '',
              "type_id": item["type_id"]?.toString() ?? '',
              "unit_id": unitID,
              "barcode_id": item["barcode_id"]?.toString() ?? '',
              "quantity": item["quantity"]?.toString() ?? '',
              "available_stock": item["available_stock"]?.toString() ?? '',
              "categories": categoryTitle,
              "type": typeName,
              "category_id": categoryID,
              "color": colorTitle,
              "size_id": sizeID,
              "color_id": colorID,
              "tax_id": taxId,
              "image": image,
              "Brand": brand,
              "Unit": unit,
              "date": formattedDate,
              "supplier": supplier,
              "currencySymbol": currencySymbol,
              "sizeTitle": sizeTitle,
              "isFeatured": isFeatured,
            };
          }).toList(),
        );
        productList.addAll(resolvedProducts);
        productList.refresh();
      } else {
        productList.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class CreateProductController extends GetxController {
  final ProductController productController = Get.put(ProductController());
  final dependencyController = Get.put(ProductDependencyController());
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final Rx<TextEditingController> title = TextEditingController().obs;
  final Rx<TextEditingController> filePathController =
      TextEditingController().obs;
  final RxInt parentCategoryID = 0.obs;
  final RxString parentCategoryValue = ''.obs;
  final RxInt categoryID = 0.obs;
  final RxString categoryValue = ''.obs;
  final RxInt brandID = 0.obs;
  final RxString brandValue = ''.obs;
  final RxInt unitId = 0.obs;
  final RxString unitValue = ''.obs;
  final RxInt taxId = 0.obs;
  final RxString taxValue = ''.obs;
  final Rx<TextEditingController> tax = TextEditingController().obs;
  final RxInt typeID = 0.obs;
  final RxString typeValue = ''.obs;
  final RxInt colorID = 0.obs;
  final RxString colorValue = ''.obs;
  final RxInt sizeID = 0.obs;
  final RxString sizeValue = ''.obs;
  final RxBool isFeatured = false.obs;
  final RxBool isPromotionalSale = false.obs;
  final RxInt supplierID = 0.obs;
  final RxString supplierValue = ''.obs;
  final RxString discountType = ''.obs;
  final RxString taxType = ''.obs;
  final RxString taxMethod = ''.obs;
  final Rx<TextEditingController> price = TextEditingController().obs;
  final Rx<TextEditingController> availableStock = TextEditingController().obs;
  final Rx<TextEditingController> discount = TextEditingController().obs;
  final Rx<TextEditingController> productCode = TextEditingController().obs;
  final Rx<TextEditingController> quantity = TextEditingController().obs;
  final Rx<TextEditingController> startDate = TextEditingController().obs;
  final Rx<TextEditingController> endDate = TextEditingController().obs;
  final Rx<TextEditingController> promoPrice = TextEditingController().obs;

  final RxList<Map<String, dynamic>> parentWiseCategory =
      <Map<String, dynamic>>[].obs;

  void createProduct() async {
    isLoading.value = true;
    await _createProduct();
    isLoading.value = false;
  }

  Future _createProduct() async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    try {
      final supplierIDValue =
          supplierID.value == 0 ? '' : supplierID.value.toString();
      final brandIDValue = brandID.value == 0 ? '' : brandID.value.toString();
      final typeIDValue = typeID.value == 0 ? '' : typeID.value.toString();
      final sizeIDValue = sizeID.value == 0 ? '' : sizeID.value.toString();
      final colorIDValue = colorID.value == 0 ? '' : colorID.value.toString();
      final taxIDValue = taxId.value == 0 ? '' : taxId.value.toString();
      final unitIdValue = unitId.value == 0 ? '' : unitId.value.toString();
      final categoryIDValue =
          categoryID.value == 0 ? '' : categoryID.value.toString();
      final isFeaturedValue = isFeatured.value ? '1' : '0';
      final isPromoSaleValue = isPromotionalSale.value ? '1' : '0';
      final startDateValue =
          isPromotionalSale.value ? startDate.value.text : '';
      final endDateValue = isPromotionalSale.value ? endDate.value.text : '';
      final promoPriceValue =
          isPromotionalSale.value ? promoPrice.value.text : '';
      final taxTypeValue = taxType.value == 'Fixed' || taxType.value == ''
          ? taxType.value = 'Fixed'
          : taxType.value;
      final discountTypeValue =
          discountType.value == 'Fixed' || discountType.value == ''
              ? discountType.value = 'Fixed'
              : discountType.value;
      final url = Uri.parse("${await AppStrings.getBaseUrlV1()}products/save");

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["supplierId"] = supplierIDValue
        ..fields["brandId"] = brandIDValue
        ..fields["typeId"] = typeIDValue
        ..fields["taxId"] = taxIDValue
        ..fields["taxAmount"] = tax.value.text
        ..fields["taxType"] = taxTypeValue
        ..fields["unitId"] = unitIdValue
        ..fields["title"] = title.value.text
        ..fields["quantity"] = quantity.value.text
        ..fields["price"] = price.value.text
        ..fields["discount"] = discount.value.text
        ..fields["isFeatured"] = isFeaturedValue
        ..fields["isPromoSale"] = isPromoSaleValue
        ..fields["taxMethod"] = taxMethod.value
        ..fields["discountType"] = discountTypeValue
        ..fields["productCode"] = productCode.value.text
        ..fields["promoPrice"] = promoPriceValue
        ..fields["promoStartAt"] = startDateValue
        ..fields["promoEndAt"] = endDateValue
        ..fields["status"] = "active"
        ..fields["categoryId"] = categoryIDValue
        ..fields["colorVariantId"] = colorIDValue
        ..fields["sizeVariantId"] = sizeIDValue;
      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'productFile', selectedFile.value!.path));
      }
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      if (jsonMap['data'] != null && jsonMap['data'].isNotEmpty) {
        Get.back();
        productController.getAllProducts();

        Get.snackbar(
          "Success",
          "Product Created Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedFile.value = File(image.path);
      String fileName = image.path.split('/').last;
      filePathController.value.text = fileName;
    }
  }
}

class UpdateProductController extends GetxController {
  final ProductController productController = Get.put(ProductController());
  final dependencyController = Get.put(ProductDependencyController());
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final Rx<TextEditingController> title = TextEditingController().obs;
  final Rx<TextEditingController> filePathController =
      TextEditingController().obs;
  final RxInt categoryID = 0.obs;
  final RxString categoryValue = ''.obs;
  final RxInt brandID = 0.obs;
  final RxString brandValue = ''.obs;
  final RxInt unitId = 0.obs;
  final RxString unitValue = ''.obs;
  final RxInt taxId = 0.obs;
  final RxString taxValue = ''.obs;
  final Rx<TextEditingController> tax = TextEditingController().obs;
  final RxInt typeID = 0.obs;
  final RxString typeValue = ''.obs;
  final RxInt colorID = 0.obs;
  final RxString colorValue = ''.obs;
  final RxInt sizeID = 0.obs;
  final RxString sizeValue = ''.obs;
  final RxBool isFeatured = false.obs;
  final RxBool isPromotionalSale = false.obs;
  final RxInt supplierID = 0.obs;
  final RxString supplierValue = ''.obs;
  final RxString discountType = ''.obs;
  final RxString taxType = ''.obs;
  final RxString taxMethod = ''.obs;
  final Rx<TextEditingController> price = TextEditingController().obs;
  final Rx<TextEditingController> availableStock = TextEditingController().obs;
  final Rx<TextEditingController> discount = TextEditingController().obs;
  final Rx<TextEditingController> productCode = TextEditingController().obs;
  final Rx<TextEditingController> quantity = TextEditingController().obs;
  final Rx<TextEditingController> startDate = TextEditingController().obs;
  final Rx<TextEditingController> endDate = TextEditingController().obs;
  final Rx<TextEditingController> promoPrice = TextEditingController().obs;

  void updateProduct(dynamic product) async {
    isLoading.value = true;
    await _updateProduct(productObj: product);
    isLoading.value = false;
  }

  Future<void> _updateProduct({required dynamic productObj}) async {
    isLoading.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    try {
      final supplierIDValue = supplierID.value == 0
          ? productObj['supplier_id']
          : supplierID.value.toString();
      final brandIDValue = brandID.value == 0
          ? productObj['brand_id']
          : brandID.value.toString();
      final typeIDValue =
          typeID.value == 0 ? productObj['type_id'] : typeID.value.toString();
      final sizeIDValue =
          sizeID.value == 0 ? productObj['size_id'] : sizeID.value.toString();
      final colorIDValue = colorID.value == 0
          ? productObj['color_id']
          : colorID.value.toString();
      final taxIDValue =
          taxId.value == 0 ? productObj['tax_id'] : taxId.value.toString();
      final unitIdValue =
          unitId.value == 0 ? productObj['unit_id'] : unitId.value.toString();
      final categoryIDValue = categoryID.value == 0
          ? productObj['category_id']
          : categoryID.value.toString();
      final isFeaturedValue = isFeatured.value
          ? '1'
          : productObj['is_featured'] == '0'
              ? '0'
              : '1';
      final isPromoSaleValue = isPromotionalSale.value
          ? '1'
          : productObj['is_promo_sale'] == '0'
              ? '0'
              : '1';
      final startDateValue = isPromotionalSale.value
          ? startDate.value.text
          : productObj['promo_start_at'] ?? '';
      final endDateValue = isPromotionalSale.value
          ? endDate.value.text
          : productObj['promo_end_at'] ?? '';
      final promoPriceValue = isPromotionalSale.value
          ? promoPrice.value.text
          : productObj['promo_price'] ?? '';
      final taxTypeValue =
          taxType.value.isEmpty ? productObj['tax_type'] : taxType.value;
      final discountTypeValue = discountType.value.isEmpty
          ? productObj['discount_type']
          : discountType.value;
      final productID = productObj['id'] ?? '';

      final url = Uri.parse(
          "${await AppStrings.getBaseUrlV1()}products/update/$productID");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields["_method"] = 'PUT'
        ..fields["supplierId"] = supplierIDValue
        ..fields["brandId"] = brandIDValue
        ..fields["typeId"] = typeIDValue
        ..fields["taxId"] = taxIDValue
        ..fields["taxAmount"] =
            tax.value.text.isEmpty ? productObj['tax'] : tax.value.text
        ..fields["taxType"] = taxTypeValue
        ..fields["unitId"] = unitIdValue
        ..fields["title"] =
            title.value.text.isEmpty ? productObj['title'] : title.value.text
        ..fields["quantity"] = quantity.value.text.isEmpty
            ? productObj['quantity']
            : quantity.value.text
        ..fields["price"] =
            price.value.text.isEmpty ? productObj['price'] : price.value.text
        ..fields["discount"] = discount.value.text.isEmpty
            ? productObj['discount']
            : discount.value.text
        ..fields["isFeatured"] = isFeaturedValue
        ..fields["isPromoSale"] = isPromoSaleValue
        ..fields["taxMethod"] =
            taxMethod.value.isEmpty ? productObj['tax_method'] : taxMethod.value
        ..fields["discountType"] = discountTypeValue
        ..fields["productCode"] = productCode.value.text.isEmpty
            ? productObj['product_code']
            : productCode.value.text
        ..fields["promoPrice"] = promoPriceValue
        ..fields["promoStartAt"] = startDateValue
        ..fields["promoEndAt"] = endDateValue
        ..fields["status"] = "active"
        ..fields["categoryId"] = categoryIDValue
        ..fields["colorVariantId"] = colorIDValue
        ..fields["sizeVariantId"] = sizeIDValue;
      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'productFile', selectedFile.value!.path));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      if (jsonMap['data'] == 1 && jsonMap['success'] == true) {
        Get.back();
        productController.getAllProducts();

        Get.snackbar(
          "Success",
          "Product Updated Successfully",
          backgroundColor: ColorSchema.success.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );

        title.value.text = '';
        isFeatured.value = false;
        isPromotionalSale.value = false;
        promoPrice.value.text = '';
      } else {
        Get.snackbar(
          "Error",
          "Failed to Update Product",
          backgroundColor: ColorSchema.danger.withOpacity(0.5),
          colorText: ColorSchema.white,
          animationDuration: const Duration(milliseconds: 800),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to Update Product",
        backgroundColor: ColorSchema.danger.withOpacity(0.5),
        colorText: ColorSchema.white,
        animationDuration: const Duration(milliseconds: 800),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedFile.value = File(image.path);
      String fileName = image.path.split('/').last;
      filePathController.value.text = fileName;
    }
  }
}
