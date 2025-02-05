class BookServiceResponse {
  int? code;
  String? message;
  bool? status;

  BookServiceResponse({this.code, this.message, this.status});

  BookServiceResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
