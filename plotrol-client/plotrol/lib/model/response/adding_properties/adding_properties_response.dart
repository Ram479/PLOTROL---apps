class AddYourPropertiesResponse {
  int? code;
  String? message;
  bool? status;

  AddYourPropertiesResponse({this.code, this.message, this.status});

  AddYourPropertiesResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
