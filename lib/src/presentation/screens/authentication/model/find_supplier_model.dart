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
