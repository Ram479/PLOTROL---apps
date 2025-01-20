class CreateAccountResponse {
  int? code;
  Details? details;
  String? message;
  bool? status;

  CreateAccountResponse({this.code, this.details, this.message, this.status});

  CreateAccountResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Details {
  int? userid;
  String? authname;
  String? firstname;
  String? lastname;
  String? profileimage;
  String? password;
  String? email;
  String? contactno;
  int? configid;
  String? devicetype;
  String? userfcmtoken;
  String? address;
  String? suburb;
  String? city;
  String? state;
  String? postcode;

  Details(
      {this.userid,
        this.authname,
        this.firstname,
        this.lastname,
        this.profileimage,
        this.password,
        this.email,
        this.contactno,
        this.configid,
        this.devicetype,
        this.userfcmtoken,
        this.address,
        this.suburb,
        this.city,
        this.state,
        this.postcode});

  Details.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    authname = json['authname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileimage = json['profileimage'];
    password = json['password'];
    email = json['email'];
    contactno = json['contactno'];
    configid = json['configid'];
    devicetype = json['devicetype'];
    userfcmtoken = json['userfcmtoken'];
    address = json['address'];
    suburb = json['suburb'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['authname'] = this.authname;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['profileimage'] = this.profileimage;
    data['password'] = this.password;
    data['email'] = this.email;
    data['contactno'] = this.contactno;
    data['configid'] = this.configid;
    data['devicetype'] = this.devicetype;
    data['userfcmtoken'] = this.userfcmtoken;
    data['address'] = this.address;
    data['suburb'] = this.suburb;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postcode'] = this.postcode;
    return data;
  }
}
