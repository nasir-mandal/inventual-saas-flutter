class CouponCodeModel {
  bool? success;
  CouponCodeData? data;

  CouponCodeModel({this.success, this.data});

  CouponCodeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? CouponCodeData.fromJson(json['data']) : null;
  }
}

class CouponCodeData {
  int? id;
  String? code;
  String? type;
  String? amount;
  String? details;
  String? status;
  String? createdAt;
  String? updatedAt;

  CouponCodeData(
      {this.id,
      this.code,
      this.type,
      this.amount,
      this.details,
      this.status,
      this.createdAt,
      this.updatedAt});

  CouponCodeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    type = json['type'];
    amount = json['amount'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
