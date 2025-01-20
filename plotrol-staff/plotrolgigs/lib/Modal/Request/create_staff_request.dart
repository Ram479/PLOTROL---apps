class CreateAccountRequest {
  int? userid;
  int? configid;
  String? contactno;
  String? firstname;
  String? lastname;
  String? email;
  String? address;
  String? suburb;
  String? city;
  String? state;
  int? partnerid;
  String? profileimage;
  Staffsettings? staffsettings;

  CreateAccountRequest(
      {this.userid,
        this.configid,
        this.contactno,
        this.firstname,
        this.lastname,
        this.email,
        this.address,
        this.suburb,
        this.city,
        this.state,
        this.partnerid,
        this.profileimage,
        this.staffsettings});

  CreateAccountRequest.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    configid = json['configid'];
    contactno = json['contactno'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    address = json['address'];
    suburb = json['suburb'];
    city = json['city'];
    state = json['state'];
    partnerid = json['partnerid'];
    profileimage = json['profileimage'];
    staffsettings = json['staffsettings'] != null
        ? new Staffsettings.fromJson(json['staffsettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['configid'] = this.configid;
    data['contactno'] = this.contactno;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['address'] = this.address;
    data['suburb'] = this.suburb;
    data['city'] = this.city;
    data['state'] = this.state;
    data['partnerid'] = this.partnerid;
    data['profileimage'] = this.profileimage;
    if (this.staffsettings != null) {
      data['staffsettings'] = this.staffsettings!.toJson();
    }
    return data;
  }
}

class Staffsettings {
  int? staffsettingsid;
  int? userid;
  int? partnerid;
  String? identificationno;
  int? yearsofexperience;
  int? experience;
  String? levelofexperience;
  int? baseprice;
  String? accountno;
  String? accountname;
  int? accounttypeid;
  String? accounttpye;
  String? bankname;
  String? ifsccode;
  String? branch;
  int? status;

  Staffsettings(
      {this.staffsettingsid,
        this.userid,
        this.partnerid,
        this.identificationno,
        this.yearsofexperience,
        this.experience,
        this.levelofexperience,
        this.baseprice,
        this.accountno,
        this.accountname,
        this.accounttypeid,
        this.accounttpye,
        this.bankname,
        this.ifsccode,
        this.branch,
        this.status});

  Staffsettings.fromJson(Map<String, dynamic> json) {
    staffsettingsid = json['staffsettingsid'];
    userid = json['userid'];
    partnerid = json['partnerid'];
    identificationno = json['identificationno'];
    yearsofexperience = json['yearsofexperience'];
    experience = json['experience'];
    levelofexperience = json['levelofexperience'];
    baseprice = json['baseprice'];
    accountno = json['accountno'];
    accountname = json['accountname'];
    accounttypeid = json['accounttypeid'];
    accounttpye = json['accounttpye'];
    bankname = json['bankname'];
    ifsccode = json['ifsccode'];
    branch = json['Branch'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staffsettingsid'] = this.staffsettingsid;
    data['userid'] = this.userid;
    data['partnerid'] = this.partnerid;
    data['identificationno'] = this.identificationno;
    data['yearsofexperience'] = this.yearsofexperience;
    data['experience'] = this.experience;
    data['levelofexperience'] = this.levelofexperience;
    data['baseprice'] = this.baseprice;
    data['accountno'] = this.accountno;
    data['accountname'] = this.accountname;
    data['accounttypeid'] = this.accounttypeid;
    data['accounttpye'] = this.accounttpye;
    data['bankname'] = this.bankname;
    data['ifsccode'] = this.ifsccode;
    data['Branch'] = this.branch;
    data['status'] = this.status;
    return data;
  }
}
