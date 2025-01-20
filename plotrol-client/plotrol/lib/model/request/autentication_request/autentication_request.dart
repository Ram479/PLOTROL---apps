class LoginRequest {
  String? contactno;
  int? configid;
  String? devicetype;
  String? userfcmtoken;
  String? deviceid;

  LoginRequest(
      {this.contactno,
        this.configid,
        this.devicetype,
        this.userfcmtoken,
        this.deviceid});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    contactno = json['contactno'];
    configid = json['configid'];
    devicetype = json['devicetype'];
    userfcmtoken = json['userfcmtoken'];
    deviceid = json['deviceid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactno'] = this.contactno;
    data['configid'] = this.configid;
    data['devicetype'] = this.devicetype;
    data['userfcmtoken'] = this.userfcmtoken;
    data['deviceid'] = this.deviceid;
    return data;
  }
}
