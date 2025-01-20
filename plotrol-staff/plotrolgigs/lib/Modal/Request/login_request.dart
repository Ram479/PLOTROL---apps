class LoginRequest {
  String? contactno;
  String? devicetype;
  int? configid;
  String? deviceid;
  String? userfcmtoken;

  LoginRequest(
      {this.contactno,
        this.devicetype,
        this.configid,
        this.deviceid,
        this.userfcmtoken});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    contactno = json['contactno'];
    devicetype = json['devicetype'];
    configid = json['configid'];
    deviceid = json['deviceid'];
    userfcmtoken = json['userfcmtoken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactno'] = this.contactno;
    data['devicetype'] = this.devicetype;
    data['configid'] = this.configid;
    data['deviceid'] = this.deviceid;
    data['userfcmtoken'] = this.userfcmtoken;
    return data;
  }
}
