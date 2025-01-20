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
  String? firstname;
  String? lastname;
  String? fullname;
  String? profileimage;
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
  String? identificationno;
  String? vehiclename;
  String? vehicleno;
  String? licenseno;
  String? insoranceno;
  String? insurancedate;
  int? shiftid;
  String? starttime;
  String? endtime;
  int? shifthours;
  int? basefare;
  int? additionalcharges;
  int? orders;
  int? fuelcharge;
  String? logdate;
  int? applocationid;
  String? applocation;
  int? logseconds;
  int? riderid;
  int? experience;
  String? levelofexperience;
  String? status;

  Details(
      {this.userid,
        this.authname,
        this.configid,
        this.authmode,
        this.roleid,
        this.firstname,
        this.lastname,
        this.fullname,
        this.profileimage,
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
        this.identificationno,
        this.vehiclename,
        this.vehicleno,
        this.licenseno,
        this.insoranceno,
        this.insurancedate,
        this.shiftid,
        this.starttime,
        this.endtime,
        this.shifthours,
        this.basefare,
        this.additionalcharges,
        this.orders,
        this.fuelcharge,
        this.logdate,
        this.applocationid,
        this.applocation,
        this.logseconds,
        this.riderid,
        this.experience,
        this.levelofexperience,
        this.status});

  Details.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    authname = json['authname'];
    configid = json['configid'];
    authmode = json['authmode'];
    roleid = json['roleid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    fullname = json['fullname'];
    profileimage = json['profileimage'];
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
    identificationno = json['identificationno'];
    vehiclename = json['vehiclename'];
    vehicleno = json['vehicleno'];
    licenseno = json['licenseno'];
    insoranceno = json['insoranceno'];
    insurancedate = json['insurancedate'];
    shiftid = json['shiftid'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    shifthours = json['shifthours'];
    basefare = json['basefare'];
    additionalcharges = json['additionalcharges'];
    orders = json['orders'];
    fuelcharge = json['fuelcharge'];
    logdate = json['logdate'];
    applocationid = json['applocationid'];
    applocation = json['applocation'];
    logseconds = json['logseconds'];
    riderid = json['riderid'];
    experience = json['experience'];
    levelofexperience = json['levelofexperience'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['authname'] = this.authname;
    data['configid'] = this.configid;
    data['authmode'] = this.authmode;
    data['roleid'] = this.roleid;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['fullname'] = this.fullname;
    data['profileimage'] = this.profileimage;
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
    data['identificationno'] = this.identificationno;
    data['vehiclename'] = this.vehiclename;
    data['vehicleno'] = this.vehicleno;
    data['licenseno'] = this.licenseno;
    data['insoranceno'] = this.insoranceno;
    data['insurancedate'] = this.insurancedate;
    data['shiftid'] = this.shiftid;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['shifthours'] = this.shifthours;
    data['basefare'] = this.basefare;
    data['additionalcharges'] = this.additionalcharges;
    data['orders'] = this.orders;
    data['fuelcharge'] = this.fuelcharge;
    data['logdate'] = this.logdate;
    data['applocationid'] = this.applocationid;
    data['applocation'] = this.applocation;
    data['logseconds'] = this.logseconds;
    data['riderid'] = this.riderid;
    data['experience'] = this.experience;
    data['levelofexperience'] = this.levelofexperience;
    data['status'] = this.status;
    return data;
  }
}
