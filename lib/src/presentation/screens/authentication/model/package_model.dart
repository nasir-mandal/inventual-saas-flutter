class PackageModel {
  bool? success;
  List<PackageData>? data;

  PackageModel({this.success, this.data});

  PackageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <PackageData>[];
      json['data'].forEach((v) {
        data!.add(PackageData.fromJson(v));
      });
    }
  }
}

class PackageData {
  int? id;
  String? title;
  String? type;
  String? amount;
  int? packageValue;
  String? status;
  String? createdAt;
  String? updatedAt;

  PackageData(
      {this.id,
      this.title,
      this.type,
      this.amount,
      this.packageValue,
      this.status,
      this.createdAt,
      this.updatedAt});

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    amount = json['amount'];
    packageValue = json['package_value'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
