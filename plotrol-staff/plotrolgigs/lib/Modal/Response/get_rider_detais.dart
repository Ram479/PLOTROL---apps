class GetRiderDetails {
  int? code;
  Details? details;
  String? message;
  bool? status;

  GetRiderDetails({this.code, this.details, this.message, this.status});

  GetRiderDetails.fromJson(Map<String, dynamic> json) {
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
  String? password;
  String? email;
  String? contactno;
  String? address;
  String? suburb;
  String? city;
  String? state;
  String? postcode;
  String? profileimage;
  String? userfcmtoken;
  int? pin;
  int? partnerid;
  int? riderid;
  String? identificationno;
  int? shiftid;
  String? starttime;
  String? endtime;
  int? shifthours;
  int? basefare;
  int? additionalcharges;
  int? additionalkm;
  int? orders;
  int? fuelcharge;
  String? accountno;
  String? accountname;
  int? accounttypeid;
  String? accounttype;
  String? bankname;
  String? ifsccode;
  String? branch;
  int? staffsettingsid;
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
        this.riderid,
        this.identificationno,
        this.shiftid,
        this.starttime,
        this.endtime,
        this.shifthours,
        this.basefare,
        this.additionalcharges,
        this.additionalkm,
        this.orders,
        this.fuelcharge,
        this.accountno,
        this.accountname,
        this.accounttypeid,
        this.accounttype,
        this.bankname,
        this.ifsccode,
        this.branch,
        this.profileimage,
        this.staffsettingsid,
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
    riderid = json['riderid'];
    identificationno = json['identificationno'];
    shiftid = json['shiftid'];
    starttime = json['starttime'];
    endtime = json['endtime'];
    shifthours = json['shifthours'];
    basefare = json['basefare'];
    additionalcharges = json['additionalcharges'];
    additionalkm = json['additionalkm'];
    orders = json['orders'];
    fuelcharge = json['fuelcharge'];
    accountno = json['accountno'];
    accountname = json['accountname'];
    accounttypeid = json['accounttypeid'];
    accounttype = json['accounttype'];
    bankname = json['bankname'];
    ifsccode = json['ifsccode'];
    branch = json['branch'];
    profileimage = json['profileimage'];
    staffsettingsid = json['staffsettingsid'];
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
    data['riderid'] = this.riderid;
    data['identificationno'] = this.identificationno;
    data['shiftid'] = this.shiftid;
    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['shifthours'] = this.shifthours;
    data['basefare'] = this.basefare;
    data['additionalcharges'] = this.additionalcharges;
    data['additionalkm'] = this.additionalkm;
    data['orders'] = this.orders;
    data['fuelcharge'] = this.fuelcharge;
    data['accountno'] = this.accountno;
    data['accountname'] = this.accountname;
    data['accounttypeid'] = this.accounttypeid;
    data['accounttype'] = this.accounttype;
    data['bankname'] = this.bankname;
    data['ifsccode'] = this.ifsccode;
    data['profileimage'] = this.profileimage;
    data['branch'] = this.branch;
    data['staffsettingsid'] = this.staffsettingsid;
    data['status'] = this.status;
    return data;
  }
}
