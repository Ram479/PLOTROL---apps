class LoginResponse {
  int? code;
  Details? details;
  String? message;
  bool? status;

  LoginResponse({this.code, this.details, this.message, this.status});

  LoginResponse.fromJson(Map<String, dynamic> json) {
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
  int? configid;
  int? authmode;
  int? roleid;
  String? tenantimage;
  String? firstname;
  String? lastname;
  String? fullname;
  String? password;
  String? email;
  String? contactno;
  String? address;
  String? suburb;
  String? city;
  String? state;
  String? postcode;
  String? userfcmtoken;
  int? pin;
  int? partnerid;
  int? locationid;
  int? applocationid;
  int? tenantid;
  String? tenantname;
  String? tenantaddress;
  String? tenantcity;
  String? tenantpostcode;
  String? tenantlat;
  String? tenantlong;
  String? locationname;
  String? applocation;
  String? applatitude;
  String? applongitude;
  int? appradius;
  int? moduleid;
  int? categoryid;
  int? subcategoryid;

  Details(
      {this.userid,
        this.authname,
        this.configid,
        this.authmode,
        this.roleid,
        this.tenantimage,
        this.firstname,
        this.lastname,
        this.fullname,
        this.password,
        this.email,
        this.contactno,
        this.address,
        this.suburb,
        this.city,
        this.state,
        this.postcode,
        this.userfcmtoken,
        this.pin,
        this.partnerid,
        this.locationid,
        this.applocationid,
        this.tenantid,
        this.tenantname,
        this.tenantaddress,
        this.tenantcity,
        this.tenantpostcode,
        this.tenantlat,
        this.tenantlong,
        this.locationname,
        this.applocation,
        this.applatitude,
        this.applongitude,
        this.appradius,
        this.moduleid,
        this.categoryid,
        this.subcategoryid});

  Details.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    authname = json['authname'];
    configid = json['configid'];
    authmode = json['authmode'];
    roleid = json['roleid'];
    tenantimage = json['tenantimage'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    fullname = json['fullname'];
    password = json['password'];
    email = json['email'];
    contactno = json['contactno'];
    address = json['address'];
    suburb = json['suburb'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    userfcmtoken = json['userfcmtoken'];
    pin = json['pin'];
    partnerid = json['partnerid'];
    locationid = json['locationid'];
    applocationid = json['applocationid'];
    tenantid = json['tenantid'];
    tenantname = json['tenantname'];
    tenantaddress = json['tenantaddress'];
    tenantcity = json['tenantcity'];
    tenantpostcode = json['tenantpostcode'];
    tenantlat = json['tenantlat'];
    tenantlong = json['tenantlong'];
    locationname = json['locationname'];
    applocation = json['applocation'];
    applatitude = json['applatitude'];
    applongitude = json['applongitude'];
    appradius = json['appradius'];
    moduleid = json['moduleid'];
    categoryid = json['categoryid'];
    subcategoryid = json['subcategoryid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['authname'] = this.authname;
    data['configid'] = this.configid;
    data['authmode'] = this.authmode;
    data['roleid'] = this.roleid;
    data['tenantimage'] = this.tenantimage;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['fullname'] = this.fullname;
    data['password'] = this.password;
    data['email'] = this.email;
    data['contactno'] = this.contactno;
    data['address'] = this.address;
    data['suburb'] = this.suburb;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postcode'] = this.postcode;
    data['userfcmtoken'] = this.userfcmtoken;
    data['pin'] = this.pin;
    data['partnerid'] = this.partnerid;
    data['locationid'] = this.locationid;
    data['applocationid'] = this.applocationid;
    data['tenantid'] = this.tenantid;
    data['tenantname'] = this.tenantname;
    data['tenantaddress'] = this.tenantaddress;
    data['tenantcity'] = this.tenantcity;
    data['tenantpostcode'] = this.tenantpostcode;
    data['tenantlat'] = this.tenantlat;
    data['tenantlong'] = this.tenantlong;
    data['locationname'] = this.locationname;
    data['applocation'] = this.applocation;
    data['applatitude'] = this.applatitude;
    data['applongitude'] = this.applongitude;
    data['appradius'] = this.appradius;
    data['moduleid'] = this.moduleid;
    data['categoryid'] = this.categoryid;
    data['subcategoryid'] = this.subcategoryid;
    return data;
  }
}
