// -------------------------------------------------------------------------- //
// District Model
// -------------------------------------------------------------------------- //
class DistrictModel {
  bool? success;
  List<DistrictData>? data;

  DistrictModel({this.success, this.data});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DistrictData>[];
      json['data'].forEach((v) {
        data!.add(DistrictData.fromJson(v));
      });
    }
  }
}

class DistrictData {
  int? id;
  String? title;

  DistrictData({this.id, this.title});

  DistrictData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

// -------------------------------------------------------------------------- //
// Area Model
// -------------------------------------------------------------------------- //
class AreaModel {
  bool? success;
  List<AreaData>? data;

  AreaModel({this.success, this.data});

  AreaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AreaData>[];
      json['data'].forEach((v) {
        data!.add(AreaData.fromJson(v));
      });
    }
  }
}

class AreaData {
  int? id;
  String? title;

  AreaData({this.id, this.title});

  AreaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

// -------------------------------------------------------------------------- //
// Supplier Model
// -------------------------------------------------------------------------- //
class SupplierModel {
  bool? success;
  List<SupplierData>? data;

  SupplierModel({this.success, this.data});

  SupplierModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SupplierData>[];
      json['data'].forEach((v) {
        data!.add(SupplierData.fromJson(v));
      });
    }
  }
}

class SupplierData {
  int? id;
  Null userId;
  int? companyId;
  int? countryId;
  int? districtId;
  int? areaId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? storeName;
  String? zipCode;
  String? address;
  String? supplierCode;
  String? supplierKey;
  String? status;
  int? isGeneratedSite;
  String? createdAt;
  String? updatedAt;
  Company? company;
  Country? country;
  Area? area;

  SupplierData(
      {this.id,
      this.userId,
      this.companyId,
      this.countryId,
      this.districtId,
      this.areaId,
      this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.storeName,
      this.zipCode,
      this.address,
      this.supplierCode,
      this.supplierKey,
      this.status,
      this.isGeneratedSite,
      this.createdAt,
      this.updatedAt,
      this.company,
      this.country,
      this.area});

  SupplierData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    countryId = json['country_id'];
    districtId = json['district_id'];
    areaId = json['area_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    storeName = json['store_name'];
    zipCode = json['zip_code'];
    address = json['address'];
    supplierCode = json['supplier_code'];
    supplierKey = json['supplier_key'];
    status = json['status'];
    isGeneratedSite = json['is_generated_site'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
  }
}

class Company {
  int? id;
  String? companyName;
  String? status;
  Null createdAt;
  Null updatedAt;

  Company(
      {this.id, this.companyName, this.status, this.createdAt, this.updatedAt});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Country {
  int? id;
  String? countryName;
  String? status;
  String? createdAt;
  String? updatedAt;

  Country(
      {this.id, this.countryName, this.status, this.createdAt, this.updatedAt});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Area {
  int? id;
  int? districtId;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  Area(
      {this.id,
      this.districtId,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['district_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
